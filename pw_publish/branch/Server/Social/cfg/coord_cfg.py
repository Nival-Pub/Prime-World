# -*- coding: cp1251 -*-

#!/usr/bin/env python
#
# (C) Dan Vorobiev 2011, Nival Network

##----------------------------------------------------------------------------------------------------------------------
## ������������� (�������) ����� ���������, �� ������� ����� �������� ������� �������
COORDINATOR_BALANCER_EXTERNAL = "127.0.0.1:88"

##----------------------------------------------------------------------------------------------------------------------
## ������������� (�������) ����� ���������, �� ������� �� SSL ����� �������� �������, � ��������� � PW Connect
COORDINATOR_BALANCER_PWCONNECT = "127.0.0.1:888"

##----------------------------------------------------------------------------------------------------------------------
## ���������� (��������) ����� ���������, �� ������� ����� �������� ������ ������� �������� (��������, ����� ������� �� ��������� �������� �� ���� �� ���-������)
COORDINATOR_BALANCER_INTERNAL = "127.0.0.1:8888"


##----------------------------------------------------------------------------------------------------------------------
## ��������� "�������� ��������" [name] -> server_id, port...
COORDINATOR_WS_SERVERS = {
    "one": { "addr":"127.0.0.1:8801", "on":0, "ka":0, "max_users":1500 },
    "two": { "addr":"127.0.0.1:8802", "on":1, "ka":0, "max_users":1500 },
}

##----------------------------------------------------------------------------------------------------------------------
## ��������� memcache-��������
COORDINATOR_MC_SERVER_LIST = [
]

CLUSTER_MC_SERVER_COUNT = 0


##----------------------------------------------------------------------------------------------------------------------
## ���������� ��������� sql-��������
COORDINATOR_SQL_CONFIG = [
## ��������! � �������������� ������� ������ ���� ������ ���� ���� pw1
    { "sql_host":"localhost:3306", "sql_base":"pw1", "sql_user":"pw", "sql_pass":"123" },
    { "sql_host":"localhost:3306", "sql_base":"pw2", "sql_user":"pw", "sql_pass":"123" },
]

##----------------------------------------------------------------------------------------------------------------------
## ���������� ��������� mongoDB-��������
COORDINATOR_MONGO_CONFIG = [
## ��������! � �������������� ������� ������ ���� ������ ���� ���� pw1
    { "mongo_addr":"localhost", "mongo_port":27017, "mongo_base":"pw1", "network_timeout":10 },
    { "mongo_addr":"localhost", "mongo_port":27017, "mongo_base":"pw2", "network_timeout":10 },
]

##----------------------------------------------------------------------------------------------------------------------
## ���������� ������� �����/���������
COORDINATOR_HTTP_CURL_WORKERS = 32
COORDINATOR_HTTP_CURL_CONNECTIONS = 16

COORDINATOR_ZZIMA_BILLING_THREADS = 2

COORDINATOR_SQL_THREADS = 2
COORDINATOR_MEMCACHE_THREADS = 2
COORDINATOR_MONGO_THREADS = 2

COORDINATOR_PWC_SMTP_THREADS = 8

COORDINATOR_SERIAL_MODEL_DATA_THREADS = 2

# ����������� �� ���������� ������������� http-�������� � ������ ������, �� ������ API (��������, ���-�� ������������ ������� ��������� � ����� WS �� self.I.WSX)
COORDINATOR_HTTP_REQUEST_LIMIT = 12

##----------------------------------------------------------------------------------------------------------------------
## data mirroring config
COORDINATOR_MIRROR_QUEUE_CONFIG = \
    { "sql_host":"localhost:3306", "sql_base":"pw_mirror", "sql_user":"pwm", "sql_pass":"123" }
COORDINATOR_MIRROR_QUEUE_THREADS = 2

COORDINATOR_MIRROR_EXPORT_CONFIG = \
    { "sql_host":"localhost:3306", "sql_base":"pw_stat", "sql_user":"pws", "sql_pass":"123" }
COORDINATOR_MIRROR_EXPORT_THREADS = 2

##----------------------------------------------------------------------------------------------------------------------
## IP:����� pvx ��������
# ������� ����, �� ������� ������ �������� pvx ������ ��� ������ ������
COORDINATOR_PVX_LOGIN_ADDRESS = "127.0.0.1:35001"

# ���������� �����, �� ������� ���������� pvx gateway ������� http (�� ��������� pvx ��������� ��� gateway �� ���� ���������������� ������)
# ������ ������ ������������� ������ ������� pvx gateway, �� ������� ������ �����-����� ���������� �������������� matchmaking-������ �� ������ � ���� �������
COORDINATOR_MATCHMAKER_LOCALES = {
#    "RU": ["127.0.0.1:34000", "127.0.0.1:34001"],
    "ALL": ["127.0.0.1:34000", "127.0.0.1:34001"],
}
COORDINATOR_MATCHMAKER_DEFAULT_LOCALE = "RU"

# ��������, ������� ������������� ��� �������� � ���������� ������������ �������,
# ���� �� ������� �� snid = 'msv'.
# ��������� ��� ������ ��������� �� �����������.
COORDINATOR_MATCHMAKER_MSV_LOCALE = "MASSIVE"
COORDINATOR_MATCHMAKER_MSV_GEOLOCATION = "MASSIVE"

##----------------------------------------------------------------------------------------------------------------------
## IP:���� � ����� ��� ��������� ����� soap-������ � ZZima billing
# ������
#~ COORDINATOR_ZZIMA_WSDL = 'http://SITE.com:8080/API/PL/ZZServiceWeb.asmx?WSDL'
#~ COORDINATOR_ZZIMA_SERVICE_NAME = 'pw'
#~ COORDINATOR_ZZIMA_SERVICE_PASSWORD = 'password_pw'
#~ COORDINATOR_AGG_BILLING_PREFIX = ''

#~ # TEST
COORDINATOR_ZZIMA_WSDL = 'http://SITE.com:8080/API/PL/ZZServiceWeb.asmx?WSDL'
COORDINATOR_ZZIMA_SERVICE_NAME = 'pwdev'
COORDINATOR_ZZIMA_SERVICE_PASSWORD = '123'
COORDINATOR_ZZIMA_PAYMENT_SYSTEM = 'BONUSES'
COORDINATOR_AGG_BILLING_PREFIX = 'devqa_'
COORDINATOR_ZZIMA_STEAM_PAYMENT_SYSTEM = 'STEAM'
COORDINATOR_BILLING_CHECK_BALANCE_PERIOD = 120 # �������� ��� � N ������ ����c��������� ������ �����

##----------------------------------------------------------------------------------------------------------------------
## IP � ����� ��� ��������� ����� HTTP POST � ZZimaAPI

# ������ zzima api:
COORDINATOR_ZZIMA_API_URL = 'http://SITE.com/zzimaApi'
COORDINATOR_ZZIMA_API_KEY = '123'
COORDINATOR_ZZIMA_API_SECRET = '123'

#~ # TEST zzima api:
#~ COORDINATOR_ZZIMA_API_URL = 'http://SITE.com/zzimaApi'
#~ COORDINATOR_ZZIMA_API_KEY = '123'
#~ COORDINATOR_ZZIMA_API_SECRET = '123'


##----------------------------------------------------------------------------------------------------------------------
## ����� social aggregator (������ ����� � ������������)
### COORDINATOR_SOCIAL_AGGREGATOR_ADDRESS = # AP9.1 ���������� � ���������� PWC
COORDINATOR_SOCIAL_AGGREGATOR_ADDRESS = "SITE.com:88"



##----------------------------------------------------------------------------------------------------------------------
## ����� person server (������ ����� � ������������)
COORDINATOR_PERSON_SERVER_ADDRESS = "127.0.0.1:8713" #! BAD ADDRESS, ����� ��� ������� � ������� PS ������ ��������

##----------------------------------------------------------------------------------------------------------------------
## ������ ����� person-��������
COORDINATOR_FRIEND_SERVICES = [ "127.0.0.1:8714", "127.0.0.1:8715" ]
COORDINATOR_PARTY_SERVICES = [ "127.0.0.1:8716", "127.0.0.1:8717" ]
COORDINATOR_GUILD_SERVICES = [ "127.0.0.1:8718", "127.0.0.1:8719" ]
COORDINATOR_SIEGE_SERVICES = [ "127.0.0.1:8741", "127.0.0.1:8742" ]

##----------------------------------------------------------------------------------------------------------------------
## ������ ���������������� chat-��������
##COORDINATOR_CHAT_SERVICES = [ "127.0.0.1:8720", "127.0.0.1:8721" ]
COORDINATOR_CHAT_SERVICES = [ "127.0.0.1:8720" ]

##----------------------------------------------------------------------------------------------------------------------
## ������ events-�������� (��� ������ ���������� ��� �������� high-severity ����� �� http)
COORDINATOR_EVENT_SERVICES = [ "127.0.0.1:8722" ]

##----------------------------------------------------------------------------------------------------------------------
## ����� �������, ������������ ������� thrift-������ (������� �� GM Tools � �����)
COORDINATOR_THRIFT_AGENT_URL = "127.0.0.1:8706"

##----------------------------------------------------------------------------------------------------------------------
## ����� ���������� stats agent (���������, ������������ ������ �� thrift � ������� ������� ����������)
COORDINATOR_STATS_AGENT_URL = "127.0.0.1:8709"

##----------------------------------------------------------------------------------------------------------------------
## ����� �������� ������� ���������� (������ ����� � ������������) -- ���������� �������/�������� � �.�.
COORDINATOR_STATS_URL = "http://127.0.0.1:35922"

##----------------------------------------------------------------------------------------------------------------------
## ����� ������� CleanSpeak (���-������)
COORDINATOR_CLEANSPEAK_FILTER_ADDRESS = "123.com:8001" # pwn

##----------------------------------------------------------------------------------------------------------------------
## ������� �� http-������� � ������� CleanSpeak (���� ��� ��� ��� �� �� ��������, ��� �� ������ ����� 20 ��� �������)
COORDINATOR_CHAT_FILTER_TIMEOUT = 3.0

##----------------------------------------------------------------------------------------------------------------------
## ����, ����� �� ������������ ������ facebook ������ (����� ������ fb_users � ������ add_fb_users.bat)
COORDINATOR_RESTRICT_FACEBOOK_USERS = 0

##----------------------------------------------------------------------------------------------------------------------
## ����, ����� �� ������������ ������ ������������� �� location � ip
COORDINATOR_RESTRICT_LOCATIONS = 0

##----------------------------------------------------------------------------------------------------------------------
## ������ ����������� locations
COORDINATOR_RESTRICT_LOCATIONS_ALLOWED = ['RU0']

##----------------------------------------------------------------------------------------------------------------------
## ����� �� �������������� � ������ pvx-������
COORDINATOR_PVX_CAN_RECONNECT = 1

##----------------------------------------------------------------------------------------------------------------------
## ��������� ������� ���� logged-��������, ���������� ��� ������������ �������
COORDINATOR_STRICT_SIGN_CHECK = 1

##----------------------------------------------------------------------------------------------------------------------
## ���� ��������� PWC-��������, � ��������
COORDINATOR_PWC_ACTIVATION_TERM = 2*(24*60*60) ## ���� �����

##----------------------------------------------------------------------------------------------------------------------
## �� ���� ��� ��� � ������� ������� ����� �������� ����� ��� ��������� ��� PWC
COORDINATOR_PWC_RETRY_CONFIRM_PERIOD = 60*60 ## ���

##----------------------------------------------------------------------------------------------------------------------
## �� ���� ��� ��� � ������� ������� ����� �������� PWC password
COORDINATOR_PWC_RESET_PWD_PERIOD = 60*60 ## ���

##----------------------------------------------------------------------------------------------------------------------
## �� ������ ���� ������ ������ �������� ��� �����
COORDINATOR_PWC_STATIC_IMAGE_PATH = "http://SITE.com/pw_connect_images"
#COORDINATOR_PWC_STATIC_IMAGE_PATH = "file://localhost/C:/Work/_MAIL_TEMPLATE"

##----------------------------------------------------------------------------------------------------------------------
## �� ������ ������ ������ ���������� ����� �� ����������� ����� (����� ������������� ���-����� ��� ����� pw connect ���.�������)
COORDINATOR_PWC_WEBFACE = "http://127.0.0.1:88/"

##----------------------------------------------------------------------------------------------------------------------
## �� ����� ������ ������ redirect ��� ������������� PWC-�������� (ok/fail)
COORDINATOR_PWC_CONFIRM_OK = "http://SITE/pwcf/confirm_ok.html"
COORDINATOR_PWC_CONFIRM_FAIL = "http://SITE/pwcf/confirm_fail.html"

# �� ������ ������ ���������� ����� ������ ������������ PWC (����� ������ � ������, ������� "����� ������")
COORDINATOR_PWC_CHANGE_PWD = "http://127.0.0.1:88/pwcf/changepwd"

##----------------------------------------------------------------------------------------------------------------------
## �������� �� ������
COORDINATOR_PWC_CONFIRM = True

##----------------------------------------------------------------------------------------------------------------------
## ������, �� ������� ��� �������������� mm-������ � ������� ������� ������, ������� !valid
COORDINATOR_MM_VALIDATION_SECONDS = 300

##----------------------------------------------------------------------------------------------------------------------
## ����� N ������ ������ �� ���������� gateway_addr -- ������� ���� ���� ���������, � ������ ��������� ��� ������ ��������� �������
## (��������� matchmaking ������ ���������� �� ������� �����)
COORDINATOR_MM_MAX_INDIVIDUAL_GATEWAY_FAILS = 1000000

##----------------------------------------------------------------------------------------------------------------------
## ����� social exchange service (balancer)
COORDINATOR_SOCIAL_EXCHANGE_URL = "127.0.0.1:8888"

##----------------------------------------------------------------------------------------------------------------------
## ������������� garbage collection (� ��������) ��� WS � PS
COORDINATOR_DEFAULT_GC_PERIOD = 60.0

##----------------------------------------------------------------------------------------------------------------------
## ������� ����� ������ � URL WebDav �������, ������� ��������� ������ � ������ �� ���������� ����� CDN.
GUILD_ICONS_UPLOAD_URL_PATTERN = "http://SITE.com/guild_logo/{guild_id}_{changes_count}.png"

##----------------------------------------------------------------------------------------------------------------------
## ������ ����������� ������� ������� (���� ������, ��������� ����� �������)
COORDINATOR_CLIENT_REVISIONS = []

COORDINATOR_STEAM_APPID = '123'
COORDINATOR_STEAM_URL = 'https://api.steampowered.com/'
COORDINATOR_STEAM_SANDBOX_MODE = True
COORDINATOR_STEAM_BILLING_BASE = 1
COORDINATOR_STEAM_APPKEY = '123'
COORDINATOR_STEAM_BILLING_OFFSET = 0

COORDINATOR_STEAM_PAYMENTS_URL = 'http://localhost:8723'
COORDINATOR_STEAM_PAYMENTS_SECRET = '123'

COORDINATOR_AERIA_PAYMENTS_URL = 'http://localhost:8723'
COORDINATOR_AERIA_PAYMENTS_SECRET = '123'

COORDINATOR_AERIA_IS_TEST = 1 # 1 - access test AeriaGames site, 0 - access live AeriaGames site

if COORDINATOR_AERIA_IS_TEST:
    COORDINATOR_AERIA_URL = "https://user:name@SITE.com/"
    COORDINATOR_AERIA_APPID = '123'
    COORDINATOR_AERIA_KEY = '123'
else:
    COORDINATOR_AERIA_URL = "https://api.aeriagames.com/"
    COORDINATOR_AERIA_APPID = '123'
    COORDINATOR_AERIA_KEY = '123'

COORDINATOR_ZZIMA_AERIA_PAYMENT_SYSTEM = 'AERIA'

COORDINATOR_SKIP_LIMIT_CHECK = True

## -------------------------------ArcGames ---------------------------------------------------------------------------##
COORDINATOR_ARCGAMES_PAYMENTS_URL = 'http://localhost:8723'
COORDINATOR_ARCGAMES_PAYMENTS_SECRET = '123'

COORDINATOR_ARCGAMES_IS_TEST = 1

if COORDINATOR_ARCGAMES_IS_TEST:
    COORDINATOR_ARCGAMES_URL = "http://SITE.arcgames.com/"
    COORDINATOR_ARCGAMES_APPABBR = "PWO"
    COORDINATOR_ARCGAMES_APPID = 123
    COORDINATOR_ARCGAMES_ZONEID = 123
    COORDINATOR_ARCGAMES_APP_SECRET = "123"
    COORDINATOR_ARCGAMES_BILLING_URL = "https://SITE.com/"
else:
    #TODO: adding data for production application
    COORDINATOR_ARCGAMES_URL = "http://SITE.com/"
    COORDINATOR_ARCGAMES_APPABBR = ""
    COORDINATOR_ARCGAMES_APPID = 0
    COORDINATOR_ARCGAMES_ZONEID =0
    COORDINATOR_ARCGAMES_APP_SECRET = ""
    COORDINATOR_ARCGAMES_BILLING_URL = "https://SITE.com/"

COORDINATOR_ZZIMA_ARCGAMES_PAYMENT_SYSTEM = 'ARCGAMES'

## -------------------------------End ArcGames -----------------------------------------------------------------------##

## -------------------------------zzima.com ---------------------------------------------------------------------------##
COORDINATOR_ZZIMACOM_PAYMENTS_URL = 'http://localhost:8723'
COORDINATOR_ZZIMACOM_PAYMENTS_SECRET = '123'

COORDINATOR_ZZIMACOM_IS_TEST = 1

if COORDINATOR_ZZIMACOM_IS_TEST:
    COORDINATOR_ZZIMACOM_URL = "http://SITE.com:8082/API/PL/ZZServiceWeb.asmx?wsdl"
    COORDINATOR_ZZIMACOM_SERVICE_NAME = 'pw'
    COORDINATOR_ZZIMACOM_PAYMENT_SYSTEM = 'CBT'
else:
    COORDINATOR_ZZIMACOM_URL = "http://SITE.com:8080/API/PL/ZZServiceWeb.asmx?wsdl"
    COORDINATOR_ZZIMACOM_SERVICE_NAME = 'pw'
    COORDINATOR_ZZIMACOM_PAYMENT_SYSTEM = 'CBT'


COORDINATOR_ZZIMA_ZZIMACOM_PAYMENT_SYSTEM = 'ZZIMA'
## -------------------------------End zzima.com---------------------------------------------------------------------------##


##----------------------------------------------------------------------------------------------------------------------
## ������ DLC
## 255250 - 255254 Steam
## aeria_initial_dlc - Gift for Aeria new users. id hardcoded

COORDINATOR_DLCS = {
    '255250' : { 'Gold' : 100, 'Premium' : 14, 'Houses' : ['FirstBuy_Dog'] , 'Resources': {'Perl' : 50, 'Resource1': 5000, 'Resource2': 5000, 'Resource3': 5000, 'Silver' : 5000 } },
    '255251' : { 'Gold' : 200, 'Premium' : 28, 'Houses' : ['FirstBuy_Dog'] , 'Resources': {'Perl' : 100, 'Resource1': 10000, 'Resource2': 10000, 'Resource3': 10000, 'Silver' : 10000 } },
    '255252' : { 'Gold' : 400, 'Premium' : 42, 'Houses' : ['FirstBuy_Dog'] , 'Resources': {'Perl' : 150, 'Resource1': 15000, 'Resource2': 10000, 'Resource3': 15000, 'Silver' : 15000 } },
    '255253' : {},
    '255254' : { 'Heroes' : [ 'witch' ], 'Skins' : [ 'ghostlord_S2_A', 'ghostlord_S2_B' ] },
    'aeria_initial_dlc' : { 'Resources': { 'Perl' : 5, 'Resource1': 5000, 'Resource2': 5000, 'Resource3': 5000, 'Silver' : 10000 } },
    'tournament0_ticket_dlc' : { 'RandomTalents' : { 'Count' : 1, 'Rarity' : 4 } },
    'dlc_for_test' : { 'Resources': { 'Silver' : 10000 } },
    'dlc_for_test_multi' : { 'Resources': { 'Silver' : 10000 }, 'MultiApply' : 1 },
    'ref_resources': { 'Resources': { 'Resource1': 5000, 'Resource2': 5000, 'Resource3': 5000, 'Silver': 5000 }, 'MultiApply' : 1 },
    'ref_premium': { 'Premium' : 3, 'MultiApply' : 1 },
    'ref_prince_unique_skin_a': { 'Skins': [ 'prince_S2_A', ], 'MultiApply' : 1 },
    'ref_prince_unique_skin_b': { 'Skins': [ 'prince_S2_B', ], 'MultiApply' : 1 },
    'ref_crystals': { 'Resources': { 'Perl' : 30 }, 'MultiApply' : 1 },
    'ref_random_rar4_talent': { 'RandomTalents' : { 'Count' : 1, 'Rarity' : 4 }, 'MultiApply' : 1 },
    'ref_random_rar5_talent': { 'RandomTalents' : { 'Count' : 1, 'Rarity' : 5 }, 'MultiApply' : 1 },
}

COORDINATOR_MUID_TO_DLCS = {
    'cenega': ['123'],
    'testmuid': ['123', '123', '123', 'tournament0_ticket_dlc', 'tournament0_ticket_dlc']
}

COORDINATOR_DEPLOY_NAME = "RU"

COORDINATOR_TOURNAMENT_SERVER = False
COORDINATOR_TOURNAMENT_SERVER_ADDR = "http://192.168.1.181:88"
COORDINATOR_TOURNAMENT_XSERVER_ADDR = "http://192.168.1.181:8888"
COORDINATOR_TOURNAMENT_SPECTATOR_AUIDS = [122]
COORDINATOR_TOURNAMENT_APPLY_RESULTS = True

COORDINATOR_PWC_INFO_URL = "http://localhost:88"

COORDINATOR_BILLING_RESERVE_ENABLED = False

COORDINATOR_GEO_DATA_PATH = 'vendor/pygeoip/data/GeoIPCity.dat'
COORDINATOR_BILLING_MERGE_DISABLED_PS = []

COORDINATOR_REDIS_CONFIG = { "redis_addr":"localhost", "redis_port":8379, "redis_base":0 }

COORDINATOR_META_MUIDS = ['mailru', 'zzima', 'aeria', 'amazon', 'cenega', 'steam', 'arc', 'zzma']
