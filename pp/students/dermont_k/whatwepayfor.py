import argparse
from couchdb import Server, PreconditionFailed, Document
from sys import exit, stdout
from lxml import html
from urllib import urlopen, urlencode

URL = 'http://www.whatwepayfor.com/api/'
func_list = ['getBudgetAccount', 'getBudgetAggregate', 'getReceiptAccount', 'getReceiptAggregate', 'getPopulation', 'getGDP', 'getDebt', 'getTaxRates', 'getInflation']

parser = argparse.ArgumentParser() #formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('f', metavar='FUNCTION', type=str, help='function', choices=func_list)
parser.add_argument('-p', '--port', metavar='NUM', type=int, help='couchdb port', default=5984)
parser.add_argument('-s', '--host', metavar='NAME', type=str, help='couchdb host', default='localhost')
parser.add_argument('-d', '--db', metavar='NAME', type=str, help='database name', default='tax')
parser.add_argument('-r', '--recreate', action="store_true", help='recreate database', default=False)
parser.add_argument('-c', '--create', action="store_true", help='create database', default=False)
parser.add_argument('-a', '--args', action="append", help='additional arguments', default=[], nargs=2)

args = parser.parse_args()
serv = Server('http://{0}:{1}/'.format(args.host, args.port))
if args.recreate:
    try:
        serv.delete(args.db)
    except:
        pass

if args.create or args.recreate:
    try:
        serv.create(args.db)
    except Exception as e:
        if not isinstance(e, PreconditionFailed):
            print 'Error creating database:', e
            exit(-1)

try:
    db = serv[args.db]
except:
    print 'Database does not exist!'
    exit(-2)

add = urlencode(dict(args.args))
try:
    s = urlopen('{0}{1}?{2}'.format(URL, args.f, add)).read()
except Exception as e:
    print 'Error getting data from {0}:'.format(URL), e
    exit(-3)

tree = html.fromstring(s)
num = len(tree.getchildren())
for n, item in enumerate(tree.getchildren()):
    print '{0} of {1}\r'.format(n + 1, num),
    stdout.flush()
    db.save({'type': args.f[3:], 'data': dict(item.attrib)})
print '{0} records saved in database.'.format(num)

