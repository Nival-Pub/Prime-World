using System.Collections.Generic;
using System.ComponentModel;
using libdb.DB;
using PF_GameLogic.DBUnit;


namespace PF_GameLogic.DBServer
{
    [Custom("DBServer")]
    [NoCode]
    public enum ESweepStage
    {
        LowerLimit,
        UpperLimit,
        WidenedLimits
    }


  [Custom("DBServer")]
  [DBVersion(1)]
  public class EstimFunctionWeights
  {
    [Description("��� ���������� ��� ���������� ������� � �������")]
    public float ladiesNumber = 1.0f;

    [Description("��� ���������� ��� ����������� ���������� ��������� ��� ����� ���������")]
    public float genderPairs = 1.0f;

    [Description("��� ���������� ��� ���������� ���������� ������")]
    public float heroes = 1.0f;

    [Description("��� ���������� ��� ������� �������� � �������, ������ ��� PVP")]
    public float ratingSpan = 1.0f;

    [Description("��� ���������� ��� ������� �������� ����� ���������� ������� �� ��������")]
    public float ratingPatternDelta = 1.0f;

    [Description("��� ���������� ��� ������� �������� �������� ���� ������")]
    public float ratingTeamAvgDelta = 1.0f;

    [Description("��� ���������� ��� ������� ����� � �������, ������ ��� PVE")]
    public float forceSpan = 1.0f;

    [Description("��� ���������� ��� ������� ����� ������, ������� ����� ����� ���������")]
    public float heroClassesDifference = 1.0f;

    [Description("��� ���������� ��� ������������� ������� ������, ������ ����� ����� ���������")]
    public float heroClassesOptimum = 1.0f;
  }


  [Custom("DBServer")]
  [DBVersion(1)]
  public class MMakingScale
  {
    [Description("������ ������� �����")]
    public int low = 100;

    [Description("������� ������� �����")]
    public int high = 1000;

    [Description("��� ����������")]
    public int step = 20;

    [Description("��������� ���������� ������� ��������� ��� ������������ �������; �������� ������� ��������� �������������")]
    public List<LerpDataItem> diffLow = new List<LerpDataItem>();

    [Description("������������ ���������� ������� ��������� ��� ������������ �������; �������� ������� ��������� �������������")]
    public List<LerpDataItem> diffHigh = new List<LerpDataItem>();
  }


  [Custom("DBServer")]
  [IndexField("heroClass")]
  [DBVersion(1)]
  public class MMakingHeroClass
  {
    public float minEfficiency = 1.0f;
    public float maxEfficiency = 1.0f;
  }



  [UseTypeName("MAPMMAKING")]
  [Custom("DBServer")]
  [DBVersion(6)]
  public class MapMMakingSettings : DBResource
  {
    [Description("�������� ����������� ��")]
    [Custom("Social")]
    public bool mock = false;

    [Description("�������� ��������� ����� ��")]
    [Custom("Social")]
    public bool isTournamentMap = false;

    [Description("���� ��������� ��������� �������")]
    public EstimFunctionWeights estimFunctionWeights = new EstimFunctionWeights();

    [Description("��������� ���������� ����� ��� ������� �������")]
    public int normalBasePointsRepeatFactor = 5;

    [Description("��������� ���������� ����� � ���������")]
    public int noobBasePointsRepeatFactor = 40;

    [Description("����� �������� ������, �� ������� ���������� ������� ��������/����� ��������� �� ����. ��������")]
    public float ratingDiffGrowTime = 180.0f;

    [Description("����������� ������� �������, �� ������� ����� ������������ ������ �������; �������� ��� ������ �������")]
    public int fullSweepSubsetLimit = 15;

    [Description("����������� ������� �������, �� ������� ����� ������������ ������ �������; ��� PVE �������")]
    public int fullSweepSubsetLimitPve = 15;

    [Description("��������� ������� ���� ����� �������, ���� ������� ����� �������� ������� ��������� � ���� ���������")]
    public int estimFunDecreaseTimeBegin = 180;

    [Description("��������� ������� ���� ����� �������, ���� ������� ����� �������� ������� ��������� � ���� ���������")]
    public int estimFunDecreaseTimeEnd = 300;

    [Description("����������� ��������� ��������� ������� � ����������� �� ������� ��������")]
    public float estimFunDecreaseFactor = 0.5f;

    [Description("����������� ��������� ��������� ������� � ����������� �� ������� ��������; � ������ ��������")]
    public float estimFunManoeuvresDecreaseFactor = 0.5f;

    [Description("���������� ���������� ���������� ������ � ��������������� �������, �� ������� ���������� ������ �������")]
    public int identicalHeroesSampleLimit = 1;

    [Description("���������� ���������� ���������� ������ � ��������������� �������, �� ������� ���������� ������ �������; ����������� �����")]
    public int identicalGuardHeroesSampleLimit = 1;

    [Description("���������� ���������� ���������� ������ � ��������������� �������, �� ������� ���������� ������ �������; ������� ����")]
    public int identicalNoobHeroesSampleLimit = 2;

    [Description("����������� ����� ��������. ���� � ���� ������������ ���� � ������� ��������, �� �������� �� ����� ������������� ��������� � lowWaitTimeFactor ���")]
    public int lowWaitTimeThreshold = 30;

    [Description("�� ������� ��� ����� ��������� ��, ���� � ���� ������������ ���� � ��������, ������� lowWaitTimeThreshold")]
    public float lowWaitTimeFactor = 2.0f;

    [Description("����������� ����� ����� � ������� �� ��� ������ ��������, �� ���� �������(�������� � �� ����� ��������������)")]
    public int manoeuvresMinPopulation = 25;

    [Description("������������ ����� ����� � ������� �� ��� ������ ��������, �� ������ �������(�������� � �� ����� ��������������)")]
    public int manoeuvresMaxPopulation = 10;

    [Description("����������� ����� ����� � ������� �� ��� ������ ����������� ��������, �� ���� ������� (�������� � �� ����� ��������������)")]
    public int guardManoeuvresMinPopulation = 10;

    [Description("������������ ����� ����� � ������� �� ��� ������ ����������� ��������, �� ������ ������� (�������� � �� ����� ��������������)")]
    public int guardManoeuvresMaxPopulation = 10;

    [Description("����������� ����� �������� ��� ������� ������� � �������� (�������� � �� ����� ��������������)")]
    public float manoeuvresWaitThreshold = 180.0f;

    [Description("����������� ������� �������, �� ������� ����� ������������ ������ ������� � ������ �������� (�������� � �� ����� ��������������)")]
    public int manoeuvresFullSweepSubset = 15; //15 - 380k combinations; 20 - 23M combinations

    [Description("��������� ���������� �������-����� � ����������")]
    public int trainingFemaleBotsCount = 1;

    [Description("��������� ���������� ������� � ����� ������ ��")]
    public int necessaryLadiesCount = 1;

    [Description("�������������� ������� � �������� ��� �������, ����������� � �� �������")]
    public List<float> partySkillCompensation = new List<float>();

    [Description("��������� ��������� ��������� lose streaks")]
    public MMakingLoseStreakCorrection loseStreakCorrection = new MMakingLoseStreakCorrection();

    [Description("����� ��������, ������� � �������� �� ����� ������������ ������� ��� '��������'")]
    public int highRatingThreshold = 1800;

    [Description("����� ��������, ������� � �������� ����� ��������� '��������', � ��� ���� �������� ������������ ����� ����������������")]
    public int proRatingThreshold = 2000;

    [Description("������������ ������� ������� ������� ��� ������� � ������� ����")]
    public int noobGamesMaxNormalRating = 1500;

    [Description("�����, ������� ����� ���������� ����������� ����������������� �������, ����� ����� ���������� '�������'")]
    public int highRatingCooldown = 60;

    [Description("����� �������� �������-�����, ����� ������� �� ����� ������� � normal-��������")]
    public float noobsTimeout = 45.0f;

    [Description("����������� ������� ���������� ����� � ������� ����, �� ������ �������")]
    public int minimalNoobsPercentage = 60;

    [Description("������� ����� ���������� full-party, ��� ����������� ������� ��������")]
    public int fullPartyGameRatingDiffMin = 30;

    [Description("������� ����� ���������� full-party, ��� ������������ ������� ��������")]
    public int fullPartyGameRatingDiffMax = 200;

    [Description("��������� ������� ����������� ������� �������� (tm)")]
    public int waitTimeSoftLimit = 240;

    [Description("��������� ������� ����������� ������� �������� (tm)")]
    public int waitTimeHardLimit = 600;

    [Description("��������� ������� ����� �������, ��������� ������ �� ������� �������(tm)")]
    public int teamLeaversTimeTrashold = 600;

    [Description("��������� ������� ������� ������� �����������, ��������� ������ �� ������� �������(tm)")]
    public int gameLeaversTimeTrashold = 300;

    [Description("��������� ����� �������� ����� � ������� pvx-����������")]
    public MMakingLocationPingSettings locationPingSettings = new MMakingLocationPingSettings();

    [Description("����������� ��������� ���� ��� ��������� � ��������������� ���� � ����������� �� ������� ��������")]
    public MMakingWaitVsProbability waitVsProbability = new MMakingWaitVsProbability();

    [Description("������ ������ ��� ������������� � ��")]
    public List<MMakingRank> ranks = new List<MMakingRank>();

    [Description("������� ���������� ��������")]
    [EnumArray(typeof(ESweepStage))]
    public List<RecessionData> recessionTableForForceMM = new List<RecessionData>();

    [Description("������� ������� � ���������� ������� �� ������ 60 ��� �������� ����� �������")]
    public List<float> recessionPremiumTable = new List<float>();

    [Description("������� ���������� �������� ��� ����� �����")]
    public RecessionFullPartyTableForForceMM recessionFullPartyTableForForceMM = new RecessionFullPartyTableForForceMM();
    
    [Description("������� ������� ��������, ������� � ������� �������� ������� � ���������� �������")]
    public float recessionPremiumTimeThreshold = 0.0f;
      
    [Description("����� ������ ���������� ������� �� playerRating ��� �������/�������/�������� ��������")]
    public RecessionTableForPlayerRatingMM recessionTableForPlayerRatingMM = new RecessionTableForPlayerRatingMM();
      
   [Description("������������ ������� ��������� ������� � �������� �� ������������� ����� ���������")]
    public int playerDiff = 5;

    [Description("����� � ������� �������� �� ������� � �������")]
    public float rankDifferenceTimePenalty = 180.0f;

    [Description("����� ���������� ���������� ������ ������� ������ �� �������, ���")]
    public float heroClassLimitsAttenuationTime = 120.0f;

    [Description("�������� ����� �� �� �������")]
    [Custom("Social")]
    public bool useRanking = false;

    [Description("������� ����������� ������������� ������� � ������� (�� ���� �������)")]
    [EnumArray(typeof(MMakingHeroClassEnum))]
    public List<MMakingHeroClass> optimalClasses = new List<MMakingHeroClass>();

    [Description("������� ������� ������� �������� � ����������� �� ���������� ������� � �������, �� 0 �� 4; ������ ��� �� �� �������")]
    public List<float> delayPerDonorLocalePlayer = new List<float>();
    
     
    [Description("������ �������, ��� ������� ��� ���������� ��������� �������")]
    [Custom("Social")]
    public int fullPartySize = 5;

    [Description("����� ������� ��������, ������� � �������� full-party ����� �������������� � ���������")]
    public float fullPartyVsRandomTimeThreshold = 30.0f;

    [Description("����� ��������, ����� ������� ����� ����� ������� � ���� � ������ ������")]
    public int localeWaitTimeThreshold = 45;

    [Description("��������� ����������� ������� ����� ��������")]
    public MMakingScale ratingScale = new MMakingScale();

    [Description("��������� ����������� ������� ����� �����")]
    public MMakingScale forceScale = new MMakingScale();

    [Description("����� ������� ������� ������ �� ���� �������")]
    public float TeamSideTimeTreshold = 120.0f;
  }



  [Custom("DBServer")]
  public class MMakingWaitVsProbability
  {
    [Description("����� ������ ��������� �������, ���")]
    public float startingWaitTime = 15.0f;

    [Description("����� ��������� ��������� �������, ���")]
    public float endingWaitTime = 180.0f;

    [Description("����������� (���) � ������ ��������� �������. ���� ����������� �� ���� ���������� �������")]
    public int startingProbabilityWeight = 100;

    [Description("����������� (���) � ����� ��������� �������. ���� ����������� �� ���� ���������� �������")]
    public int endingProbabilityWeight = 300;
  }


  [Custom("DBServer")]
  public class MMakingLoseStreakCorrection
  {
    [Description("����������� ���������� ���������� ������, � �������� �������� �������� �������� ���������")]
    public int minStreak = 2;

    [Description("����� ����� �� ������ ����������� ���������")]
    public float forcePenalty = 5.0f;

    [Description("����� �������� �� ������ ����������� ���������")]
    public float ratingPenalty = 100.0f;

    //True rocket-scince here
    //Descriptions is useless
    //See full documentation
    public int firstCaseThreshold = 2;
    public float firstCasePenalty = 0.25f;

    public int secondCaseThreshold = 3;
    public float secondCasePenalty = 0.5f;

    public int thirdCaseThreshold = 5;
    public float thirdCasePenalty = 1.0f;
  }


  [Custom("DBServer")]
  public class MMakingLocationPingSettings
  {
    [Description("��� ����� ���� ����� ������ ����� ��������� ��������")]
    public int nicePingThreshold = 40;

    [Description("����������� ������� ������������� ����� ������")]
    public float pingScaleMinFactor = 2.0f;

    [Description("������� � ������� �������� ��� ������ ������")]
    public int worstPingWaitTimePenalty = 180;

    [Description("������ ��� ������ ������� ����� �� ���������")]
    public float goodEnoughPingFactor = 0.2f;

    [Description("����� ��������, ����� �������� �� �������� ����������� ��� ����� � ������")]
    public int ratingThreshold = 1800;
  }


  [Custom("DBServer")]
  public class LerpDataItem
  {
    [Description("����������� ����������")]
    public float x;

    [Description("��������� ����������")]
    public float y;
  }


  [Custom("DBServer")]
  public class MMakingRank
  {
    [Description("����������� �������")]
    public float lowRating;

    [Description("���������� �� ������ ������ �� ���������")]
    public bool mergeWithNextRank;

    [Description("��������, ���� ����������, ����� ������� � ������ �� mergeWithNextRank ����!")]
    public int mergeRanksCount = 0;

    [Description("��� ��� ����������� � �����")]
    public string debugName;

    [Description("���� �� ������������ �������� �� ���� �� ������ ������")]
    public bool useForceMM;
    
    [Description("���� �� ������������ �������� �� ���������������� ������� �� ������ ������")]
    public bool usePlayerRatingMM;

  }

  [Custom("DBServer")]
  public class RecessionData
  {
      [Description("������� �������� �������,��������� �������� � ����, �� ������� ��� 0 ��� 1, 1 ��� 2 � �.�. ")]
      public List<float> recessionTable = new List<float>();
      [Description("������������ ������� �� ����� ��������")]
      public bool isWaitingTimePremium = true;
  }

  [Custom("DBServer")]
  public class RecessionFullPartyTableForForceMM
   {
       [Description("������� ���������� ��������")]
       public List<float> recessionTable = new List<float>();

       [Description("������� ������� � ���������� ������� �� ������ 60 ��� �������� ����� �������")]
       public List<float> recessionPremium = new List<float>();
   }

  [Custom("DBServer")]
  public class RecessionTableForPlayerRatingMM 
  {
      [EnumArray(typeof(ESweepStage))]
      public List<RecessionData> recessionTable = new List<RecessionData>();

      [Description("�������� ���������� �� ������������ ������� �� playerRating ����� �������� ������ �������")]
      public float recessionSideDiff = 0.0f;

      [Description("������� 50 � ���������� ������� �� ������ 60 ��� �������� ����� ������� recessionPremiumTimeThreshold (����������� �������, � �� �������-���������)")]
      public List<float> recessionPremiumTable = new List<float>();

      [Description("������� ������� ��������, ������� � ������� �������� ������� � ���������� ������� ��� ������� ������ �� ����������������� ��������")]
      public float recessionPremiumTimeThreshold = 0.0f;
      
      
      [Description("� ���� �� �������� � playerRating ���� ����� �������� ����� ��������� � ����� ��������. ������: �������� � playerRating 2400 � ������ �� ����� ������������� ��� �������� � playerRating 2000.")]
      public int recessionMaxPlayerRating = 2000;
      [Description("������� ������� ��������, ������� � ������� �������� ������� � ���������� ������� ��� ������� ������ �� ����������������� ��������")]
      public int recessionMinPlayerRating = 1200;

  }

}
