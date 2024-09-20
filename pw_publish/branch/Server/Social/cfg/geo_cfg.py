# -*- coding: cp1251 -*-
#!/usr/bin/env python

# ����� ����� ���� ��������� ��� geo_location (� ���������, ����� � ��� ������ ���� GEO LOCATIONS)

from base.helpers import ClassDict

# ����� ������ ������
EGeoLocation = ClassDict(
    RUSSIA  = "RU0",
    US_EAST = "US0", # "US.E",
    US_WEST = "US0", # "US.W",
    EUROPE  = "EN0",
    TURKEY  = "TR0",
)

# ����� ���������� � ������ �������� �������
GEO_LOCATIONS = [ EGeoLocation.RUSSIA, EGeoLocation.TURKEY, EGeoLocation.EUROPE ]

DEFAULT_GEO_LOCATION = EGeoLocation.RUSSIA

# ��� �������, ����� ������ �������� � ������/������/������� ����������, � ���� ������ ������ ������������� �� ���� ������
COUNTRY_2_LOC = dict(
    # ex USSR
    RU = EGeoLocation.RUSSIA,
    UA = EGeoLocation.RUSSIA,
    BY = EGeoLocation.RUSSIA,
    GE = EGeoLocation.RUSSIA, # ������
    
    # �������
    US = EGeoLocation.EUROPE,
    CA = EGeoLocation.EUROPE,
    MX = EGeoLocation.EUROPE,
    BR = EGeoLocation.EUROPE,
    CO = EGeoLocation.EUROPE, # Colombia
    PE = EGeoLocation.EUROPE, # Peru
    #...
    
    # ������
    GB = EGeoLocation.EUROPE,
    FR = EGeoLocation.EUROPE,
    DE = EGeoLocation.EUROPE,
    IT = EGeoLocation.EUROPE,
    NL = EGeoLocation.EUROPE, # Netherlands
    BE = EGeoLocation.EUROPE, # Belgium
    NO = EGeoLocation.EUROPE, # Norway
    SE = EGeoLocation.EUROPE, # Sweden
    FI = EGeoLocation.EUROPE, # Finland
    AT = EGeoLocation.EUROPE, # Austria
    ES = EGeoLocation.EUROPE, # Spain
    DK = EGeoLocation.EUROPE, # Denmark

    # ����. ������
    PL = EGeoLocation.EUROPE, # Poland
    CZ = EGeoLocation.EUROPE, # Czech
    HU = EGeoLocation.EUROPE, # Hungary
    MK = EGeoLocation.EUROPE, # Macedonia
    RO = EGeoLocation.EUROPE, # Romania
    RS = EGeoLocation.EUROPE, # Serbia
    #...
    
    # ����.������
    TR = EGeoLocation.TURKEY, # Turkey
    IL = EGeoLocation.EUROPE, # Israel
    SA = EGeoLocation.EUROPE, # Saudi Arabia
    
    # ������
    ZA = EGeoLocation.US_WEST, # South Africa
    
    # ����
    CN = EGeoLocation.US_EAST,
    TW = EGeoLocation.US_EAST, # Taiwan
    JP = EGeoLocation.US_EAST,
    KR = EGeoLocation.US_EAST, # Korea
    ID = EGeoLocation.US_EAST, # Indonesia
    IN = EGeoLocation.US_EAST, # India
    PH = EGeoLocation.US_EAST, # Philippines
    AU = EGeoLocation.US_EAST, # Australia
    TH = EGeoLocation.US_EAST, # Thailand
    VN = EGeoLocation.US_EAST, # Vietnam
)

# ���� ����� (�������, ������) �������� ������ �������������� (long1, lat1, long2, lat2), ������ �����. geo
# long: ��������� �������� +, �������� -
# lat: �������� �������� +, ����� -
LONG_LAT_2_LOC = [
    ClassDict( long1=25, long2=45, lat1=35, lat2=42, geo=EGeoLocation.TURKEY ),
    ClassDict( long1=30, long2=180, lat1=40, lat2=80, geo=EGeoLocation.RUSSIA ),
    ClassDict( long1=-30, long2=30, lat1=30, lat2=80, geo=EGeoLocation.EUROPE ),
    ClassDict( long1=-100, long2=-30, lat1=-90, lat2=90, geo=EGeoLocation.US_WEST ),
    ClassDict( long1=-180, long2=-100, lat1=-90, lat2=90, geo=EGeoLocation.US_EAST ),
]
