# encoding: utf-8
# See document "Programming Guide" at <https://www.siglentamerica.com/wp-content/uploads/dlm_uploads/2017/10/ProgrammingGuide_forSDS-1-1.pdf>
import sys
import logging
import argparse

import visa


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


def waveform(device):

    # the response to this is binary data so we need to write() and then read_raw()
    # to avoid encode() call and relative UnicodeError
    logger.info(device.write('C1: WF? DAT2')) 

    response = device.read_raw()

    logger.info(repr(response))

def dumpscreen(device, fileout):
    logger.info('DUMPING SCREEN')

    device.write('SCDP')
    response = device.read_raw()

    fileout.write(response)
    fileout.close()

    logger.info('END')

def configure_opts():
    parser = argparse.ArgumentParser(description='Use oscilloscope via VISA')

    subparsers = parser.add_subparsers(dest='cmd', help='sub-command help')

    parser_a = subparsers.add_parser('list', help='list help')
    parser_b = subparsers.add_parser('wave')
    parser_c = subparsers.add_parser('shell', help='VISA shell')
    parser_c = subparsers.add_parser('dumpscreen', help='dump screen')

    parser_b.add_argument('--device', required=True)
    parser_c.add_argument('--device', required=True)
    parser_c.add_argument('--out', type=argparse.FileType('w'), required=True)


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
        waveform(device)
    elif args.cmd == 'dumpscreen':
        dumpscreen(device, args.out)

    device.close()

