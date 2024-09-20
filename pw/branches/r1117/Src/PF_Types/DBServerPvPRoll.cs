//#include "DBHeroRanks.cs"
//#include "DBTalent.cs"
//#include "DbAchievements.cs"
//#include "DbAbility.cs"
//#include "DbHero.cs"
//#include "DbUIData.cs"

using System.Collections.Generic;
using libdb.DB;
using PF_GameLogic.DBTalent;
using PF_GameLogic.DBHeroRanks;
using PF_GameLogic.DBUnit;
using PF_GameLogic.DBStats;
using System.ComponentModel;


namespace PF_GameLogic.DBServer
{
  public enum TalentUpgradeEntityType
  {
    Rune,
    Catalyst
  }

  [UseTypeName("TALUGRDENT")]
  [DBVersion(1)]
  [IndexField("persistentId")]
  public class TalentUpgradeEntity : DBResource
  {
    [Description("ID")]
    [Custom("DBServer", "Social")]
    public string persistentId = null;

    [NoCode]
    [Custom("Social")]
    public TextRef description = new TextRef();

    [NoCode]
    [Custom("Social")]
    public TextRef tooltip = new TextRef();

    [NoCode]
    [Custom("Social")]
    [Description("������")]
    public DBPtr<Render.DBRenderResources.Texture> icon;

    [Description("���: ���������� ��� �����������")]
    [Custom("DBServer", "Social")]
    public TalentUpgradeEntityType type;

    [Description("������������ ���-�� ����� �� �������� ����� ������")]
    [Custom("DBServer", "Social")]
    public int talentLevelLimit;

    [Description("���� ������������")]
    [Custom("DBServer", "Social")]
    public int probability;
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  public class RollItemProbability
  {
    [Description("��� ����� ��� ����� �� ���������� - probability ���� ������ ������������ ����� ������������ �����������. � ��������� -1 ����������� ������ �����.")]
    public float probability = 0;
    public DBPtr<RollItem> item;
  }

  [Custom( "DBServer", "Social" )]
  [NonTerminal]
  public class RollItem : DBResource
  {
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class TalentRollItem : RollItem
  {
    public DBPtr<Talent> talent;
  }

  [Custom( "DBServer", "Social" )]
  public enum ClanWarsRollItemType
  {
    ClanRating,
    PlayerRating
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  [UseTypeName("CWROLLITEM")]
  public class ClanWarsRollItem : RollItem
  {
    public ClanWarsRollItemType type;
    public float count;
  }

  [Custom( "DBServer", "Social" )]
  public enum ResourceRollConstraint
  {
    Silver,
    Resource1, 
    Resource2,
    Resource3,
    Pearl,
    RedPearl,
    Shard,
    CustomCurrency
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  public class RollLevelInfo
  {
    public int level = 0;
    public int count = 0;
    public int deviation = 0;
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class ResourceRollItem : RollItem
  {
    public ResourceRollConstraint type;
    public string customCurrencyId;
    public List<RollLevelInfo> itemsFromLord;
    public List<RollLevelInfo> itemsFromHero;
    public List<RollLevelInfo> itemsFromRank;
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class RarityTalentListRollItem : RollItem
  {
    public ETalentRarity rarity;
  }

  [DBVersion( 0 )]
  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLCONT" )]
  public class RollContainer : RollItem
  {
    [Description( "��������� ���������� � ����������� �� ������ (�� ��������� ������ �� defaultRollContainerCostByRank ����� �������� �����)" )]
    public DBPtr<RollContainerCostByRank> costByRank;
    public string name = "";
    public List<RollItemProbability> items;
    public int multiplicator = 1;
  }

  [UseTypeName( "ROLLITEM" )]
  public class MarketingEventRollItem : RollItem
  {
    [Custom( "DBServer", "Social" )]
    public string persistentId;

    [NoCode]
    [Custom( "Social" )]
    public DBPtr<BaseMarketingEvent> marketingEvent;

    [NoCode]
    [Custom("Social")]
    public int count;

    public DBPtr<Render.DBRenderResources.Texture> image;
    public TextRef tooltip;
  }

  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class NothingRollItem : RollItem
  {
    public int dummy = 0;
  }

  [Custom( "DBServer", "Social" )]
  public class TalentUpgradeProbability
  {
    [Description( "�����������" )]
    public float probability = 0f;
    [Description( "���� ������� (����) (�� ��� ��������� ������� �������)" )]
    public int points = 0;
  }

  [Custom( "DBServer", "Social" )]
  public class TalentUpgradeProbabilityTable : DBResource
  {
    [Description( "" )]
    public List<TalentUpgradeProbability> upgrades;
  }

  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class TalentUpgradeRollItem : RollItem
  {
    [Description("����������� ����� �������")]
    public DBPtr<TalentUpgradeProbabilityTable> upgradeTable;
    [Description("����, �� �������� ������ ���������� ������")]
    public DBPtr<RollItem> talentItem;
  }

  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class HeroRollItem : RollItem
  {
    public DBPtr<Hero> hero;
  }

  [Custom( "DBServer", "Social" )]
  [UseTypeName( "ROLLITEM" )]
  public class SkinRollItem : RollItem
  {
    public DBPtr<HeroSkin> skin;
  }

  [Custom("DBServer", "Social")]
  [UseTypeName("ROLLITEM")]
  public class FlagRollItem : RollItem
  {
    public DBPtr<CustomFlag> flag;
  }

  [Custom("DBServer", "Social")]
  [UseTypeName("ROLLITEM")]
  public class PremiumAccRollItem : RollItem
  {
    [Description("������� ���� �������� ���� ������ � ��������")]
    public int days;
  }

  [Custom("DBServer", "Social")]
  [UseTypeName("ROLLITEM")]
  public class GoldRollItem : RollItem
  {
    [Description("������� ������ ������ � ��������")]
    public int count;
  }

  [Custom("DBServer", "Social")]
  [UseTypeName("ROLLITEM")]
  public class TalentUpgradeEntityRollItem : RollItem
  {
    public DBPtr<TalentUpgradeEntity> entity;
  }

  [Custom( "DBServer" )]
  public class PointsToContainers
  {
    [Description("���-�� ���� �����")]
    public int specialPoints;
    [Description("������� ����������� ������ �� ��������� ����")]
    public int containers;
  }

  [Custom( "DBServer" )]
  [UseTypeName("CONTSPEC")]
  public class ContainersBySpecialPoints : DBResource
  {
    public List<PointsToContainers> items = new List<PointsToContainers>();
  }

  [DBVersion(0)]
  [Custom( "DBServer" )]
  [UseTypeName("MODEROLL")]
  public class ModeRollSettings : DBResource
  {
    [Description("Scores cap")]
    public int scoresCap = 90;

    [Description("Explicitly roll specified number of containers if player wins")]
    public int containersOnWin = 0;

    [Description("Explicitly roll specified number of containers on player's first win of the day by player`s rank")]
    public DBPtr<RollContainerCountByRank> containersOnFWOD;

    [Description("�������������� ���-�� ����������� �� ���� ����")]
    public DBPtr<ContainersBySpecialPoints> containersBySpecialPoints;

    [Description("Allowed talent groups for roll")]
    public ETalentRollGroup allowedRollGroups = ETalentRollGroup.All;

    [Description("Default roll containers")]
    public List<DBPtr<RollContainer>> containers;

    [Description("Roll containers for premium roll")]
    public List<DBPtr<RollContainer>> premiumContainers;

    [Description( "Roll containers for additional premium roll" )]
    public List<DBPtr<RollContainer>> additionalPremiumContainers;

    [Description("Default container, rolled always")]
    public DBPtr<RollContainer> defaultContainer;

    [Description( "event awards (��� �������, ���������� �� ��������)" )]
    public List<DBPtr<RollContainer>> eventContainers;

    [Description( "premium event awards (��� ������� ��� ��, ���������� �� ��������)" )]
    public List<DBPtr<RollContainer>> premiumEventContainers;

    [Description("Hero endurance loss for session")]
    [Custom( "Social" )]
    public int enduranceGain = 40;

    [Description( "Endurance coeff (applied if hero is tired or enduranceDisableRollBoost is TRUE)" )]
    public float enduranceCoeff = 0.33f;
    public float enduranceFameCoeff = 0.33f;
    public float enduranceExperienceCoeff = 0.33f;
    public float enduranceResourcesCoeff = 0.33f;    
    [Description( "����������� ������������� ������ - �������� ������" ) ] 
    public float leaversAwardsCoeff = 0.3f;

    [Description("Reliability increment if player wins a match")]
    public int reliabilityOnFinishWin = 3;
    [Description( "Reliability increment if player loses a match" )]
    public int reliabilityOnFinishLose = 5;
    [Description("Reliability match period (duration, in seconds)")]
    public int reliabilityOnFinishPeriod = 1800;
    [Description("Reliability increment for period")]
    public int reliabilityOnFinishPerPeriod = 1;
    [Description( "Reliability increment if player leaves a match" )]
    public int reliabilityOnLeave = -3;
    [Description("Reliability leave penalty afk period (duration, in seconds)")]
    public int reliabilityOnLeavePeriod = 300;
    [Description("Reliability leave penalty")]
    public int reliabilityOnLeavePerPeriod = -1;

    [Description("Plain score multiplicator")]
    public int talentsMultiplicator = 1;
    [Description("Flag for disabling roll boost (if TRUE and hero is NOT tired enduranceCoeff if NOT applied for overall items set)")]
    public bool enduranceDisableRollBoost = true;
    [Description("heroLevel/Fame curve")]
    public List<RollLevelInfo> famePerSession;

    [Description("Fame coeff, applied if player loses a match")]
    public float fameLoseCoeff = 0.33f;
    [Description("Experience coeff, applied if player loses a match")]
    public float experienceLoseCoeff = 0.33f;
    [Description("Resources coeff, applied if player loses a match")]
    public float resourcesLoseCoeff = 1;

    [Description("heroLevel/Experience curve")]
    public List<RollLevelInfo> experiencePerSession;

    [Description( "Dodge points penalty if player leaves a guard match" )]
    public int dodgePointsOnLeave = 1;

    [Description("Rating change will be multiplied by this parameter")]
    public float ratingChangeMultiplier = 1.0f;

    [Description("����������� ������������ ������ (���). ���� ������, �� ����������� ������������. �� ��������� ���� (0).")]
    public int minSessionDuration = 0;

    [Description("Roll additional talent (from additional premium containers) for premium awarding")]
    public int applyPremiumTalent = 0;

    [Description( "First win of the day rewards" )]
    public DBPtr<RollContainer> FWODRewardContainer;

    [Custom( "Social" )]
    [Description("Mode name")]
    public string modeName;

    [Description("Version for ModeRollSettings. Change for reset users' context")]
    public int version;

    [Description("���� ����� ������/���������������, � ��� ������� ��������, �� ��� ������������� ������.")]
    public bool teamWinDisconnectedWin = false;

    [Description("Clan Wars Economic settings")]
    public DBPtr<ClanWarsSettings> clanWarsSettings;

    [Description("����������� ������ ������, ������� � ������� ����������� �����.")]
    public int fullPartySize = 4;


  }

  [Custom( "DBServer" )]
  public class RatingModifier
  {
    [Description( "������ �������� �������� �����" )]
    public int minValue = 0;
    [Description( "������� �������� �������� �����" )]
    public int maxValue = 0;
    [Description( "��������� � ������ ������" )]
    public float winModifier = 0;
    [Description( "��������� � ������ ���������" )]
    public float looseModifier = 0;
  }

  [Custom("DBServer")]
  public class FullPartyRatingModifier
  {
      [Description("������ �������� �������� �����")]
      public int minRating = 0;
      [Description("�������� �������")]
      public float ratingBonus = 0;
  }

  [UseTypeName("RCCS")]
  [Custom( "DBServer" )]
  public class RollContainerCostByRank : DBResource
  {
    public List<float> costs;
  }

  [UseTypeName("RCCT")]
  [Custom("DBServer")]
  public class RollContainerCountByRank : DBResource
  {
    public List<int> counts;
  }

  [Custom( "DBServer" )]
  public class SingleRollSettings
  {
    [Description( "��������� ��� �����" )]
    public DBPtr<RollContainer> rollContainer;

    [Description( "Allowed talent groups for roll" )]
    public ETalentRollGroup allowedRollGroups = ETalentRollGroup.All;

    [Description("������. ��������� ���� ���������� ������ �� ���������.")]
    public int version = 0;
  }

  [Custom("DBServer")]
  public class BaseModifierFromQuantity
  {
    public float quantity;
    public float percent;
  }

  [UseTypeName("CWST")]
  [Custom("DBServer")]
  public class ClanWarsSettings : DBResource
  {
    [Description("������� ��������")]
    public float basePoints = 10;
    [Description("����������� �� ���������� ������� ������ ����� � �������.")]
    public List<BaseModifierFromQuantity> partyClanMembersModifier = new List<BaseModifierFromQuantity>();
    [Description("����������� �� ���������� ������� � ��������������� �������.")]
    public List<BaseModifierFromQuantity> foeCountsModifier = new List<BaseModifierFromQuantity>();
    [Description("�������� ���������� �� ������� ������������ �����, � ����: ����� �����( �� HeroRanks) - ���������")]
    public List<float> defeatedFoeRankModifier = new List<float>();
    [Description("���� �����. % ����� ����� �� ����� ��������.")]
    public float clanPoints = .3f;
    [Description("������� �������� ����� ���������� ������������� ���������� �� ��������������� �� ���� ���� ������ ��������� � ������.")]
    public bool normalizeBySessionScores = true;
    [Description("����������� �������� ����� ������ �� ������� ���.")]
    public float premiumAccountModifier = 2f;
  }

  [DBVersion(0)]
  [UseTypeName("ROLL")]
  [Custom( "DBServer", "Social" )]
  public class RollSettings : DBResource
  {
    [Description("Used in social part only!")]
    public DBPtr<ModeRollSettings> pvp;

    [Description("��������� ����-���������� �� ������ ����� �� ���������")]
    public DBPtr<RollContainerCostByRank> defaultRollContainerCostByRank;

    [Description("��������� ��� ����� ��� ������ ������ �� ���� � ����������")]
    public DBPtr<ModeRollSettings> trainingFWODSettings;

    [Description("������������ ����������� ������� �� �������� �����")]
    public List<RatingModifier> ratingModifiers = new List<RatingModifier>();

    [Description("�������� ������� ��� ������ �� �������� �����")]
    public List<FullPartyRatingModifier> fullPartyRatingModifiers = new List<FullPartyRatingModifier>();

    [Description("��������� ��� ����� ������� (!������ ���������, ����������� ���� � Social.ROOT!)")]
    public SingleRollSettings forgeRollSettings;

    [Description("������ �� ����������� ������")]
    public DBPtr<GuildLevels> guildLevels;

    [Description("Minimum hero's level, required for exclusive (orange) talents roll")]
    public int requiredLevelForExclusiveTalents = 21;

    [Description( "Minimum hero's rating, required for exclusive (orange) talents roll" )]
    public int requiredRatingForExclusiveTalents = 1600;

    [Description("Clan Wars Economic settings")]
    public DBPtr<ClanWarsSettings> clanWarsSettings;

  }

  [Custom( "DBServer", "Social" )]
  [NonTerminal]
  [NameMapValue]
  public class GuildBonus : DBResource
  {
    public TextRef tooltip;
  }

  [Custom( "DBServer", "Social" )]
  public class GuildLevel
  {
    [Description( "requiredExp*GuildLevels.requiredExpMultiplier = ��������� ���������� ��������, ����������� ��� �������� ����� �� ������. � ��������� ������� �� ��������� ������, ��� 9 223 372 036 854 775 807 / ���������" )]
    public long requiredExp = 0;
    public TextRef title;
    public TextRef tooltip;

    public List<DBPtr<GuildBonus>> Bonuses;
  }

  [Custom( "DBServer", "Social" )]
  [UseTypeName( "GUILDLEVELS" )]
  public class GuildLevels : DBResource
  {
    [Description( "��������� ��� ������������� requiredExp � ���������. ���� ������� ������� ������� 10 ����� � ��������� 10^5, �� ����� ��������� ��� ��������� 10*10^5 = 10^6 �����" )]
    public int requiredExpMultiplier = 100000;
    public List<GuildLevel> levels;
  }

  [Custom( "DBServer", "Social" )]
  [NoCode]
  [UseTypeName( "GUILDBONUS" )]
  public class AdditionHeroExpBonus : GuildBonus
  {
    [Description("�������������� ������� ����� ����� �� ���.  �������� ��� namemap'�")]
    [NameMapValue]
    public int percent = 0;
  }

  [Custom( "DBServer", "Social" )]
  [NoCode]
  [UseTypeName( "GUILDBONUS" )]
  public class GuildResourceBonus : GuildBonus
  {
    [NameMapValue]
    [Description( "���-�� ������������ ������� �� ���. �������� ��� namemap'�")]
    public int resource = 0;
  }

  [Custom( "DBServer", "Social" )]
  [NoCode]
  [UseTypeName( "GUILDBONUS" )]
  public class RandomTalentBonus : GuildBonus
  {
    [Description( "��������� ��� ���������� �����" )]
    public SingleRollSettings singleRollSettings = new SingleRollSettings();
  }

  //��������� ����� ��� ������ �������
  [Custom("DBServer", "Social")]
  [NoCode]
  public class BaseMarketingEvent : DBResource
  {
  }

}
