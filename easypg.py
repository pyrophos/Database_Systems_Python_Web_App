"""
EasyPG - a module to make it easier to connect to PostgreSQL with different configurations.

:version: 7
"""

from contextlib import closing, contextmanager
import psycopg2
from ConfigParser import SafeConfigParser

def connect(context=True, autocommit=True, **kwargs):
    """
    Connects to the database.  Configuration is read from the configuration
    file ``pgapp.cfg``, if available.

    :param context: whether to wrap the connection in an auto-closing context manager.
    :param kwargs: Default configuration parameters.
    :return: The database connection, wrapped in a context manager for a ``with`` block.
    :rtype: psycopg2.Connection
    """
    cp = SafeConfigParser()
    cp.read('pgapp.cfg')
    opts = dict(kwargs.items())
    opts.update(cp.items('database'))
    cxn = psycopg2.connect(**opts)
    cxn.autocommit = autocommit
    if context:
        return closing(cxn)
    else:
        return cxn

@contextmanager
def cursor(**kwargs):
    """
    Context-managed cursor and database connection.  This will yield a cursor,
    and close both the cursor and the database connection.
    :param kwargs: The connection arguments.
    :return:
    """
    dbc = connect(context=False, **kwargs)
    try:
        cur = dbc.cursor()
        try:
            yield cur
        finally:
            dbc.close()
    finally:
        dbc.close()

def demo():
    with cursor() as cur:
        print "connected to database"

if __name__ == '__main__':
    demo()
