    /// ��������� �������.
    NAMED_ENUM(TalentUsed, 0),

    /// �������� �������.
    NAMED_ENUM(TalentUnlocked, 1),

    /// ���������� �������.
    NAMED_ENUM(ImpulsiveBuffUsed, 2),

    /// ���������� ������������� ������.
    NAMED_ENUM(MaxLevelReached, 3), // obsolete

    /// ���������� ���������� �����.
    NAMED_ENUM(TimeSliceResults, 4),

    //����������� ���� (����� ����). 
    NAMED_ENUM(MG2BoostUsage, 5),
    
    //������ ��������. 
    NAMED_ENUM(MG2Started, 6),
    
    //�������� ������ ��� ���������� ��2.���� ����� ��������� - ���������
    NAMED_ENUM(MG2LevelFailed, 7),

    //����� ������� ������ �� ��������� (����� ��� ����)
    NAMED_ENUM(MG2BallsChanged, 8),
    
    //����������� zzgold 
    NAMED_ENUM(MG2ZZBoostUsed, 9), 

    //�������� ���������
    NAMED_ENUM(MG2LevelWon, 10),
    
    //������ ���������
    NAMED_ENUM(MG2LevelStarted, 11),

    //������������� ������� ������
    NAMED_ENUM(HeroKill, 12),

    //id ������, id �������a
    NAMED_ENUM(HeroDeath, 13), //(���� ����� ��������� ������ �������, �� � "id ������" ���������� ������������� ������-�������, "id ��������" �������� ������, ���� �� ����� ��������� ���������, �� � "id" �������� ���������� ������������� ��������-�������, "id ������" � ����� ������ �������� ������)
    
    //id ������ (�������� �����)
    NAMED_ENUM(KillAssist, 14), 
    
    //������� ���������
    NAMED_ENUM(LevelUp, 17), 
    
    //����, ����
    NAMED_ENUM(ConsumableBought, 18), 
      
    //����
    NAMED_ENUM(ConsumableUsed, 19), 
    
    //������
    NAMED_ENUM(Deed, 20), 

    //����� (������� � �� �����)
    NAMED_ENUM(Ressurection, 21),

    //any building is destroyed
    NAMED_ENUM(BuildingDestroyed, 22),

    //������� �����. ��� ������ � � ����� �����
    NAMED_ENUM(FlagPoleRaised, 23),

    //������� �����. ��� ������� � � ����� �����
    NAMED_ENUM(FlagPoleDropped, 24),

    //����� �� ��2
    NAMED_ENUM(MG2Exit, 25),

    //���������� ������ ��������.
    NAMED_ENUM(TalentSwitchedOff, 26),

    //��������� ����� �� ������� �����.
    NAMED_ENUM(NaftaIncomeFromHero, 27),

    //��������� ����� �� ������� ��������.
    NAMED_ENUM(NaftaIncomeFromCreature, 28),

    //��������� ����� �� ������������� ������.
    NAMED_ENUM(NaftaIncomeFromBuilding, 29),

    //��������� ����� �� ������������� �������.
    NAMED_ENUM(NaftaIncomeFromTalent, 30),

    //����������� ��������� �������
    NAMED_ENUM(ImpulsiveBuffSuggested, 31),

    //������������� ����
    NAMED_ENUM(CheatUsed, 32),

    //��������� ����� �� ����������� ����.
    NAMED_ENUM(NaftaIncomeFromImpulsiveBuff, 33),

    //��������� ����� �� ��������.
    NAMED_ENUM(NaftaIncomeFromMinigame, 34),

    //����������� ZZ ����� � ��������
    NAMED_ENUM(MG2ZZBoostSuggested, 35),

    //���������� ������ � �����
    NAMED_ENUM(IgnoreAdd, 36),

    //�������� ������ �� ������
    NAMED_ENUM(IgnoreRemove, 37),

    //��������� ���� �������� ���� (������� ����)
    NAMED_ENUM(SpawnerDead, 38),

    //�������� �����
    NAMED_ENUM(ToggleOnBridge, 39),

    // ��������� �� ������
    NAMED_ENUM(AltarChanneling, 40),

    //��������� ����� �� ������.
    NAMED_ENUM(NaftaIncomeFromAchievement, 41),

    // Script events
    NAMED_ENUM(ScriptEvent, 42),
