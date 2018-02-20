# encoding: utf-8
# See document "Programming Guide" at <https://www.siglentamerica.com/wp-content/uploads/dlm_uploads/2017/10/ProgrammingGuide_forSDS-1-1.pdf>
import sys
import logging
import argparse
import wave # https://docs.python.org/2/library/wave.html

import visa # https://pyvisa.readthedocs.io


logging.basicConfig()

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def usage(progname):
    print 'usage: %s [list|dump]' % progname
    sys.exit(1)

def list(r):
    results = r.list_resources()

    for idx, result in enumerate(results):
        print '[%03d] %s' % (idx, result)


def waveform(device, outfile, channel):

    sample_rate = device.query('SANU C%d?' % channel)

    sample_rate = int(sample_rate[len('SANU '):-2])
    logger.info('detected sample rate of %d' % sample_rate)

    #desc = device.write('C%d: WF? DESC' % channel)
    #logger.info(repr(device.read_raw()))

    # the response to this is binary data so we need to write() and then read_raw()
    # to avoid encode() call and relative UnicodeError
    logger.info(device.write('C%d: WF? DAT2' % (channel,))) 

    response = device.read_raw()

    if not response.startswith('C%d:WF ALL' % channel):
        raise ValueError('error: bad waveform detected -> \'%s\'' % repr(response[:80]))

    index = response.index('#9')
    index_start_data = index + 2 + 9
    data_size = int(response[index + 2:index_start_data])
    # the reponse terminates with the sequence '\n\n\x00' so
    # is a bit longer that the header + data
    data = response[index_start_data:index_start_data + data_size]
    logger.info('data size: %d' % data_size)

    fd = wave.open(outfile, "w")
    fd.setparams((
        1,               # nchannels
        1,               # sampwidth
        sample_rate,     # framerate
        data_size,       # nframes
        "NONE",          # comptype
        "not compresse", # compname
    ))
    fd.writeframes(data)
    fd.close()

    logger.info('saved wave file')

def dumpscreen(device, fileout):
    logger.info('DUMPING SCREEN')

    device.write('SCDP')
    response = device.read_raw()

    fileout.write(response)
    fileout.close()

    logger.info('END')

def template(device):
    response = device.query('TEMPLATE ?')

    print response

def configure_opts():
    parser = argparse.ArgumentParser(description='Use oscilloscope via VISA')

    subparsers = parser.add_subparsers(dest='cmd', help='sub-command help')

    parser_a = subparsers.add_parser('list', help='list help')
    parser_wave = subparsers.add_parser('wave')
    parser_c = subparsers.add_parser('shell', help='VISA shell')
    parser_c = subparsers.add_parser('dumpscreen', help='dump screen')
    parser_template = subparsers.add_parser('template', help='dump the template for the waveform descriptor')

    parser_wave.add_argument('--device', required=True)
    parser_wave.add_argument('--out', type=argparse.FileType('w'), required=True)
    parser_wave.add_argument('--channel', type=int, required=True)

    parser_c.add_argument('--device', required=True)
    parser_c.add_argument('--out', type=argparse.FileType('w'), required=True)

    parser_template.add_argument('--device', required=True)

    return parser


if __name__ == '__main__':
    parser = configure_opts()
    args = parser.parse_args()

    resources = visa.ResourceManager('@py')

    if args.cmd == 'list':
        list(resources)
        sys.exit(0)
    elif args.cmd == 'shell':
        from pyvisa import shell
        shell.main(library_path='@py')
        sys.exit(0)

    device = resources.open_resource(args.device, write_termination='\n', query_delay=0.25)
    idn = device.query('*IDN?')

    logger.info('Connected to device \'%s\'' % idn)

    if args.cmd == 'wave':
        waveform(device, args.out, args.channel)
    elif args.cmd == 'dumpscreen':
        dumpscreen(device, args.out)
    elif args.cmd == 'template':
        template(device)

    device.close()

