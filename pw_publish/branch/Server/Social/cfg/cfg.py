# -*- coding: cp1251 -*-

#!/usr/bin/env python
#
# (C) Dan Vorobiev 2011, Nival Network
from binascii import crc32   # zlib version is not cross-platform
from base.helpers import json_dumps

##----------------------------------------------------------------------------------------------------------------------
## ������������� (�������) ����� ���������, �� ������� ����� �������� ������� �������
BALANCER_EXTERNAL = "127.0.0.1:88"

##----------------------------------------------------------------------------------------------------------------------
## ������������� (�������) ����� ���������, �� ������� �� SSL ����� �������� �������, � ��������� � PW Connect
BALANCER_PWCONNECT = "127.0.0.1:888"

##----------------------------------------------------------------------------------------------------------------------
## ���������� (��������) ����� ���������, �� ������� ����� �������� ������ ������� �������� (��������, ����� ������� �� ��������� �������� �� ���� �� ���-������)
BALANCER_INTERNAL = "127.0.0.1:8888"

##----------------------------------------------------------------------------------------------------------------------
## ���������� ��������� memcache-�������� -- �� �������� ��� ������ �����������
CLUSTER_MC_SERVER_LIST = []
CLUSTER_MC_SERVER_CRC32 = [] # ��������� ������ MC-�������� ����� ����������� ��������, ����� ����� ������� [ crc(CLUSTER_MC_SERVER_LIST) ], ����� mc-threads ������, ����� ������ ��������

CLUSTER_MC_SERVER_COUNT = 0

def resetMcServers( mc_list=None ):
    global CLUSTER_MC_SERVER_COUNT
    global CLUSTER_MC_SERVER_CRC32
    if mc_list != None:
        CLUSTER_MC_SERVER_LIST[:] = mc_list[:]
    CLUSTER_MC_SERVER_COUNT = len(CLUSTER_MC_SERVER_LIST)
    CLUSTER_MC_SERVER_CRC32[:] = [ crc32( ",".join(CLUSTER_MC_SERVER_LIST) ) ] # � sql-threads ����� ���������� ��� �� ��������� �� ��� ��������
    

##----------------------------------------------------------------------------------------------------------------------
## ���������� ��������� sql-�������� -- �� �������� ��� ������ �����������
CLUSTER_SQL_SERVER_COUNT = 0
CLUSTER_SQL_CONFIG = []
CLUSTER_SQL_SERVER_CRC32 = [] # ��������� ������ SQL-��������/��� ����� ����������� ��������, ����� ����� ������� [ crc(SERVER_LIST) ], ����� ������, ����� ������ ��������

def resetSqlServers( sql_list=None ):
    global CLUSTER_SQL_SERVER_COUNT
    global CLUSTER_SQL_SERVER_CRC32
    if sql_list != None:
        CLUSTER_SQL_CONFIG[:] = sql_list[:]
    CLUSTER_SQL_SERVER_COUNT = len(CLUSTER_SQL_CONFIG)
    json_list = json_dumps(sql_list)
    CLUSTER_SQL_SERVER_CRC32[:] = [ crc32( json_list ) ] # � sql-threads ����� ���������� ��� �� ��������� �� ��� ��������


##----------------------------------------------------------------------------------------------------------------------
## ���������� ��������� mongoDB-�������� -- �� �������� ��� ������ �����������
CLUSTER_MONGO_SERVER_COUNT = 0
CLUSTER_MONGO_CONFIG = [
    { "mongo_addr":"localhost", "mongo_port":27017, "mongo_base":"pw1", "network_timeout":10 },
    { "mongo_addr":"localhost", "mongo_port":27017, "mongo_base":"pw2", "network_timeout":10 },
]
CLUSTER_MONGO_SERVER_CRC32 = [] # ��������� ������ ��������/��� ����� ����������� ��������, ����� ����� ������� [ crc(SERVER_LIST) ], ����� ������, ����� ������ ��������

def resetMongoServers( mongo_list=None ):
    global CLUSTER_MONGO_SERVER_COUNT
    global CLUSTER_MONGO_SERVER_CRC32
    if mongo_list != None:
        CLUSTER_MONGO_CONFIG[:] = mongo_list[:]
    CLUSTER_MONGO_SERVER_COUNT = len(CLUSTER_MONGO_CONFIG)
    json_list = json_dumps(mongo_list)
    CLUSTER_MONGO_SERVER_CRC32[:] = [ crc32( json_list ) ] # � thread-pool ����� ���������� ��� �� ��������� �� ��� ��������


##----------------------------------------------------------------------------------------------------------------------
## ���������� ������� �����/���������
HTTP_CURL_WORKERS = 128
HTTP_CURL_CONNECTIONS = 64

HTTP_REQUEST_LIMIT = 64

ZZIMA_BILLING_THREADS = 20

SQL_THREADS = 2
MEMCACHE_THREADS = 2
MONGO_THREADS = 2

PWC_SMTP_THREADS = 8

SERIAL_MODEL_DATA_THREADS = 2

##----------------------------------------------------------------------------------------------------------------------
## data mirroring config
MIRROR_QUEUE_CONFIG = \
    { "sql_host":"localhost:3306", "sql_base":"pw_mirror", "sql_user":"pwm", "sql_pass":"pwmdata" }
MIRROR_QUEUE_THREADS = 2

MIRROR_EXPORT_CONFIG = \
    { "sql_host":"localhost:3306", "sql_base":"pw_stat", "sql_user":"pws", "sql_pass":"pwsdata" }
MIRROR_EXPORT_THREADS = 2

##----------------------------------------------------------------------------------------------------------------------
PVX_LOGIN_ADDRESS = "127.0.0.1:35001"

MATCHMAKER_LOCALES = {
    # "RU": ["127.0.0.1:34000", "127.0.0.1:34001"], # � ������ ��������� �� ��������� 2 gateway
    "RU": ["127.0.0.1:34000"], # � ������ 1, ����� �� �������� ����� ����� fake mathmaker-���
}
MATCHMAKER_DEFAULT_LOCALE = "RU"

##----------------------------------------------------------------------------------------------------------------------
## ����� zzima billing/authorization (������ ����� � ������������)
ZZIMA_WSDL = ""
ZZIMA_SERVICE_NAME = ""
ZZIMA_SERVICE_PASSWORD = ""
ZZIMA_PAYMENT_SYSTEM = ""

AGG_BILLING_PREFIX = ""

BILLING_CHECK_BALANCE_PERIOD = 30 # �������� ��� � N ������ ����c��������� ������ �����

##----------------------------------------------------------------------------------------------------------------------
## IP � ����� ��� ��������� ����� HTTP POST � ZZimaAPI
ZZIMA_API_URL = ""
ZZIMA_API_KEY = ""
ZZIMA_API_SECRET = ""

##----------------------------------------------------------------------------------------------------------------------
## ����� social aggregator (������ ����� � ������������)
SOCIAL_AGGREGATOR_ADDRESS = "127.0.0.1:8703"

##----------------------------------------------------------------------------------------------------------------------
## ����� person server (������ ����� � ������������)
PERSON_SERVER_ADDRESS = "127.0.0.1:8704"

##----------------------------------------------------------------------------------------------------------------------
## ����� ������� ���������� (������ ����� � ������������) -- ���������� �������/�������� � �.�.
STATS_AGENT_URL = "127.0.0.1:8709"


##----------------------------------------------------------------------------------------------------------------------
## (������ ����� � ������������, ����� �������� � ���. ��� ������)
PVX_CAN_RECONNECT = 1

##----------------------------------------------------------------------------------------------------------------------
## ����� �� ��������� ������
#TODO:LOFIK:ENCIPHER_TRAFFIC
#ENCIPHER_TRAFFIC = 0

##----------------------------------------------------------------------------------------------------------------------
## ���� ��������� PWC-��������, � ����
PWC_ACTIVATION_DAYS = 2
## ... � ��������
PWC_ACTIVATION_TERM = PWC_ACTIVATION_DAYS*(24*60*60) ## ���� �����

##----------------------------------------------------------------------------------------------------------------------
## �� ���� ��� ��� � ������� ������� ����� �������� ����� ��� ��������� ��� PWC
PWC_RETRY_CONFIRM_PERIOD = 60*60 ## ���

##----------------------------------------------------------------------------------------------------------------------
## �� ���� ��� ��� � ������� ������� ����� �������� PWC password
PWC_RESET_PWD_PERIOD = 60*60 ## ���

##----------------------------------------------------------------------------------------------------------------------
## DEBUG: ��������� �� ������ fake pwc auid-�� (����� ��� ����� ��� �������� ��� ������ ���.�����������)
PWC_ALLOW_FAKE_AUIDS = 1

##----------------------------------------------------------------------------------------------------------------------
## DEBUG: ��������� ����� ����� pwconnect ��� �������� �������
PWC_SKIP_SIGNATURE_CHECK = 0

##----------------------------------------------------------------------------------------------------------------------
## ������, �� ������� ��� �������������� mm-������ � ������� ������� ������, ������� !valid
MM_VALIDATION_SECONDS = 300

##----------------------------------------------------------------------------------------------------------------------
## ����� N ������ ������ �� ���������� gateway_addr -- ������� ���� ���� ���������, � ������ ��������� ��� ������ ��������� ������� 
## (��������� matchmaking ������ ���������� �� ������� �����)
MM_MAX_INDIVIDUAL_GATEWAY_FAILS = 1000000

##----------------------------------------------------------------------------------------------------------------------
## ����� social exchange service (balancer)
SOCIAL_EXCHANGE_URL = "127.0.0.1:88"

GUILD_SERVICES = []

##-----------------------------------------------------------------------------------------------------------------------
## Maximum number of stat records stored while being resended.
STATS_RESEND_POOL_LIMIT = 10000

RESTRICT_FACEBOOK_USERS = False
RESTRICT_LOCATIONS = False

SKIP_LIMIT_CHECK = True
TOURNAMENT_SERVER = False

GEO_DATA_PATH = 'vendor/pygeoip/data/GeoIPCity.dat'
BILLING_MERGE_DISABLED_PS = []

COORDINATOD_PREDEFINED_LOCALES = {'fb#9999999999999': 'US'}

META_MUIDS = ['mailru', 'zzima', 'aeria', 'amazon', 'cenega', 'steam', 'arcgames']

MERGE_REFUND_GOLD_ALLOWED = False
MERGE_TRANSFER_GOLD_ALLOWED = False
