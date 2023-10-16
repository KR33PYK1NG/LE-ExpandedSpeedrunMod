Class SFXSaveGame
    native;

// Types
const MaxSaveSize = 1048576;
struct native GamerProfileSaveRecord 
{
    var(GamerProfileSaveRecord) array<ProfileBOOLSaveRecord> BoolVariables;
    var(GamerProfileSaveRecord) array<ME1_ProfileINTSaveRecord> IntVariables;
    var(GamerProfileSaveRecord) array<ME1_ProfileFLOATSaveRecord> FloatVariables;
    var(GamerProfileSaveRecord) array<ME1_PlotManagerAchievementSaveRecord> PlotManagerAchievementMaps;
    var(GamerProfileSaveRecord) array<ME1_ProfilePlaythroughSaveRecord> lstPlaythroughs;
    var(GamerProfileSaveRecord) array<ME1_ProfileRewardSaveRecord> RewardStats;
    var(GamerProfileSaveRecord) array<int> AchievementStates;
    var(GamerProfileSaveRecord) array<ME1_BonusTalentSaveRecord> UnlockedBonusTalents;
    var(GamerProfileSaveRecord) array<ME1_BonusTalentSaveRecord> PassiveBonusTalents;
    var(GamerProfileSaveRecord) array<int> IntStats;
    var(GamerProfileSaveRecord) array<float> FloatStats;
    var(GamerProfileSaveRecord) array<ME1_CharacterProfileSaveRecord> lstCharacterProfiles;
    var(GamerProfileSaveRecord) ME1_GameOptionsSaveRecord GameOptions;
    var(GamerProfileSaveRecord) string LastPlayedCharacterID;
    var(GamerProfileSaveRecord) string LastSaveGame;
    var(GamerProfileSaveRecord) int LastUsedPlaythroughID;
    var(GamerProfileSaveRecord) float LowestPlaythroughDamageTaken;
    var(GamerProfileSaveRecord) int MostMoneyAccumulated;
    var(GamerProfileSaveRecord) int MostPlaythroughPlayerKills;
    var(GamerProfileSaveRecord) int LowestPlaythroughPlayerDeaths;
    var(GamerProfileSaveRecord) float FastestPlaythroughTime;
};
struct native ME1_CharacterProfileSaveRecord 
{
    var string characterID;
    var string FullName;
    var ME1_CharacterStatisticsSaveRecord CharacterStatistics;
    var int LastPlayedSlot;
    var int CharacterLevel;
    var int CreationYear;
    var int CreationMonth;
    var int CreationDayOfWeek;
    var int CreationDay;
    var int CreationHour;
    var int CreationMin;
    var int CreationSec;
    var int CreationMSec;
    var int PlayedHours;
    var int PlayedMin;
    var int PlayedSec;
    var byte ClassBase;
    var byte Origin;
    var byte Reputation;
};
struct native ME1_CharacterStatisticsSaveRecord 
{
    var int Stamina;
    var int Focus;
    var int Precision;
    var int Coordination;
};
struct native ME1_ProfilePlaythroughSaveRecord 
{
    var int PlaythroughID;
    var int DifficultySetting;
};
struct native ME1_ProfileRewardSaveRecord 
{
    var string sName;
    var int Value;
    var int UnlockedAt;
    var int AchievementId;
    var int TalenTreeID;
    var bool IsAchievementUnlocked;
};
struct native ME1_BonusTalentSaveRecord 
{
    var int AchievementId;
    var int BonusTalentID;
};
struct native ME1_PlotManagerAchievementSaveRecord 
{
    var int PMIndex;
    var int AchievementId;
    var int UnlockedAt;
};
struct native ME1_ProfileFLOATSaveRecord 
{
    var int PMIndex;
    var float Value;
};
struct native ME1_ProfileINTSaveRecord 
{
    var int PMIndex;
    var int Value;
};
struct native ProfileBOOLSaveRecord 
{
    var int PMIndex;
    var int Value;
};
struct native SaveTimeStamp 
{
    var(SaveTimeStamp) int SecondsSinceMidnight;
    var(SaveTimeStamp) int Day;
    var(SaveTimeStamp) int Month;
    var(SaveTimeStamp) int Year;
};
struct native PlotTableSaveRecord 
{
    struct native PlotCodex 
    {
        struct native PlotCodexPage 
        {
            var(PlotCodexPage) int Page;
            var(PlotCodexPage) bool bNew;
        };
        var(PlotCodex) array<PlotCodexPage> Pages;
    };
    struct native PlotQuest 
    {
        var(PlotQuest) array<int> History;
        var(PlotQuest) int QuestCounter;
        var(PlotQuest) bool bQuestUpdated;
    };
    var(PlotTableSaveRecord) array<int> BoolVariables;
    var(PlotTableSaveRecord) array<int> IntVariables;
    var(PlotTableSaveRecord) array<float> FloatVariables;
    var(PlotTableSaveRecord) array<PlotQuest> QuestProgress;
    var(PlotTableSaveRecord) array<int> QuestIDs;
    var(PlotTableSaveRecord) array<PlotCodex> CodexEntries;
    var(PlotTableSaveRecord) array<int> CodexIDs;
    var(PlotTableSaveRecord) int QuestProgressCounter;
};
struct native HenchmanSaveRecord 
{
    var(HenchmanSaveRecord) array<PowerSaveRecord> Powers;
    var(HenchmanSaveRecord) array<ME1_SimpleTalentSaveRecord> simpleTalents;
    var(HenchmanSaveRecord) array<ComplexTalentSaveRecord> complexTalents;
    var(HenchmanSaveRecord) array<ME1_ItemSaveRecord> Equipment;
    var(HenchmanSaveRecord) array<ME1_ItemSaveRecord> Weapons;
    var Name LoadoutWeapons[6];
    var(HenchmanSaveRecord) Name Tag;
    var Name MappedPower;
    var(HenchmanSaveRecord) int CharacterLevel;
    var(HenchmanSaveRecord) int TalentPoints;
    var(HenchmanSaveRecord) int TalentPoolPoints;
    var(HenchmanSaveRecord) int AutoLevelUpTemplateID;
    var(HenchmanSaveRecord) int LastName;
    var(HenchmanSaveRecord) int ClassName;
    var float HealthPerLevel;
    var float StabilityCurrent;
    var float ToxicCurrent;
    var int Stamina;
    var int Focus;
    var int Precision;
    var int Coordination;
    var float HealthCurrent;
    var float ShieldCurrent;
    var float HealthMax;
    var(HenchmanSaveRecord) int XPLevel;
    var bool HelmetShown;
    var(HenchmanSaveRecord) byte ClassBase;
    var byte gender;
    var byte Race;
    var byte AttributePrimary;
    var byte AttributeSecondary;
    var(HenchmanSaveRecord) EBioItemWeaponRangedType CurrentQuickSlot;
};
struct native PlayerSaveRecord 
{
    var(PlayerSaveRecord) AppearanceSaveRecord Appearance;
    var(PlayerSaveRecord) string FirstName;
    var(PlayerSaveRecord) array<ME1_ItemSaveRecord> Items;
    var(PlayerSaveRecord) array<ME1_ItemSaveRecord> BuybackItems;
    var(PlayerSaveRecord) array<ME1_SimpleTalentSaveRecord> simpleTalents;
    var(PlayerSaveRecord) array<ComplexTalentSaveRecord> complexTalents;
    var(PlayerSaveRecord) array<PowerSaveRecord> Powers;
    var(PlayerSaveRecord) array<ME1_ItemSaveRecord> Equipment;
    var(PlayerSaveRecord) array<ME1_ItemSaveRecord> IWeapons;
    var(PlayerSaveRecord) array<WeaponSaveRecord> Weapons;
    var(PlayerSaveRecord) array<HotKeySaveRecord> HotKeys;
    var(PlayerSaveRecord) array<ME1_HotKeySaveRecord> legacyHotKeys;
    var(PlayerSaveRecord) string FaceCode;
    var(PlayerSaveRecord) ME1_GameOptionsSaveRecord GameOptions;
    var(PlayerSaveRecord) transient Class<SFXPawn_Player> PlayerClass;
    var Name LoadoutWeapons[6];
    var(PlayerSaveRecord) ME1ImportBonusSaveRecord ME1ImportBonuses;
    var(PlayerSaveRecord) Name PlayerClassName;
    var(PlayerSaveRecord) Name MappedTalent;
    var(PlayerSaveRecord) Name MappedPower1;
    var(PlayerSaveRecord) Name MappedPower2;
    var(PlayerSaveRecord) Name MappedPower3;
    var(PlayerSaveRecord) Name PrimaryWeapon;
    var(PlayerSaveRecord) Name SecondaryWeapon;
    var(PlayerSaveRecord) Name LastPower;
    var(PlayerSaveRecord) int LegacyPlayerClassName;
    var(PlayerSaveRecord) int srClassFriendlyName;
    var(PlayerSaveRecord) int Level;
    var(PlayerSaveRecord) float CurrentXP;
    var(PlayerSaveRecord) int XPLevel;
    var(PlayerSaveRecord) int LastName;
    var(PlayerSaveRecord) int TalentPoints;
    var(PlayerSaveRecord) int TalentPoolPoints;
    var(PlayerSaveRecord) int Credits;
    var(PlayerSaveRecord) int Medigel;
    var(PlayerSaveRecord) float Grenades;
    var(PlayerSaveRecord) float OmniGel;
    var(PlayerSaveRecord) int Eezo;
    var(PlayerSaveRecord) int Iridium;
    var(PlayerSaveRecord) int Palladium;
    var(PlayerSaveRecord) int Platinum;
    var(PlayerSaveRecord) int Probes;
    var(PlayerSaveRecord) float CurrentFuel;
    var int SpecializationBonusID;
    var(PlayerSaveRecord) int AutoLevelUpTemplateID;
    var float HealthPerLevel;
    var float StabilityCurrent;
    var float ToxicCurrent;
    var int Stamina;
    var int Focus;
    var int Precision;
    var int Coordination;
    var float SkillCharm;
    var float SkillIntimidate;
    var float SkillHaggle;
    var float HealthCurrent;
    var float ShieldCurrent;
    var float HealthMax;
    var(PlayerSaveRecord) int LastQuickSlot;
    var(PlayerSaveRecord) bool bIsFemale;
    var bool isDriving;
    var bool ArmorOverridden;
    var bool HelmetShown;
    var(PlayerSaveRecord) byte LegacyPlayerClass;
    var(PlayerSaveRecord) EOriginType Origin;
    var(PlayerSaveRecord) ENotorietyType Notoriety;
    var byte SpectreRank;
    var byte Race;
    var byte AttributePrimary;
    var byte AttributeSecondary;
    var(PlayerSaveRecord) EBioItemWeaponRangedType CurrentQuickSlot;
};
struct native ME1ImportBonusSaveRecord 
{
    var(ME1ImportBonusSaveRecord) int ImportedME1Level;
    var(ME1ImportBonusSaveRecord) int StartingME2Level;
    var(ME1ImportBonusSaveRecord) float BonusXP;
    var(ME1ImportBonusSaveRecord) float BonusCredits;
    var(ME1ImportBonusSaveRecord) float BonusResources;
    var(ME1ImportBonusSaveRecord) float BonusParagon;
    var(ME1ImportBonusSaveRecord) float BonusRenegade;
};
struct native ME1_VehicleSaveRecord 
{
    var(ME1_VehicleSaveRecord) string FirstName;
    var(ME1_VehicleSaveRecord) stringref LastName;
    var float HealthCurrent;
    var float ShieldCurrent;
};
struct native ME1_HotKeySaveRecord 
{
    var(ME1_HotKeySaveRecord) int HotKeyPawn;
    var(ME1_HotKeySaveRecord) int HotKeyEvent;
};
struct native HotKeySaveRecord 
{
    var(HotKeySaveRecord) Name PawnName;
    var(HotKeySaveRecord) int PowerID;
};
struct native PowerSaveRecord 
{
    var(PowerSaveRecord) Name PowerName;
    var(PowerSaveRecord) Name PowerClassName;
    var(PowerSaveRecord) float CurrentRank;
    var(PowerSaveRecord) int WheelDisplayIndex;
};
struct native ME1_GameOptionsSaveRecord 
{
    var array<int> GameOptions;
};
enum eOption
{
    OPTION_TYPE_COMBAT_DIFFICULTY,
    OPTION_TYPE_DIALOG_MODE,
    OPTION_TYPE_AUTO_LEVELUP,
    OPTION_TYPE_AUTO_EQUIP,
    OPTION_TYPE_TUTORIAL_FLAG,
    OPTION_TYPE_SUBTITLES,
    OPTION_TYPE_AUTOPAUSE_ENEMY_SIGHTED,
    OPTION_TYPE_AUTOPAUSE_SQUADMEMBER_DOWN,
    OPTION_TYPE_BRIGHTNESS,
    OPTION_TYPE_DISPLAY_SETTING,
    OPTION_TYPE_MUSIC_VOLUME,
    OPTION_TYPE_FX_VOLUME,
    OPTION_TYPE_DIALOG_VOLUME,
    OPTION_TYPE_INVERT_YAXIS,
    OPTION_TYPE_SOUTHPAW_FLAG,
    OPTION_TYPE_TARGET_ASSIST_MODE,
    OPTION_TYPE_H_COMBAT_SENSITIVITY,
    OPTION_TYPE_V_COMBAT_SENSITIVITY,
    OPTION_TYPE_H_EXPLORATION_SENSITIVITY,
    OPTION_TYPE_V_EXPLORATION_SENSITIVITY,
    OPTION_TYPE_RUMBLE_FLAG,
    OPTION_TYPE_AUTOPAUSE_BLEEDOUT,
    OPTION_TYPE_MOTION_BLUR,
    OPTION_TYPE_FILM_GRAIN,
    OPTION_TYPE_SQUAD_POWER_USE,
    OPTION_TYPE_AUTO_SAVE,
    OPTION_TYPE_STICK_CONFIGURATION,
    OPTION_TYPE_TRIGGER_CONFIGURATION,
    OPTION_TYPE_VERTICAL_SYNC,
};
struct native ME1_PlotPseudoItemSaveRecord 
{
    var(ME1_PlotPseudoItemSaveRecord) int LocalizedName;
    var(ME1_PlotPseudoItemSaveRecord) int LocalizedDesc;
    var(ME1_PlotPseudoItemSaveRecord) int ExportID;
    var(ME1_PlotPseudoItemSaveRecord) int basePrice;
    var(ME1_PlotPseudoItemSaveRecord) int ShopGUIImageID;
    var(ME1_PlotPseudoItemSaveRecord) int PlotConditional;
};
struct native WeaponSaveRecord 
{
    var(WeaponSaveRecord) ME1_ItemSaveRecord Item;
    var(WeaponSaveRecord) Name WeaponClassName;
    var(WeaponSaveRecord) Name AmmoPowerName;
    var(WeaponSaveRecord) int AmmoUsedCount;
    var(WeaponSaveRecord) int TotalAmmo;
    var(WeaponSaveRecord) bool bLastWeapon;
    var(WeaponSaveRecord) bool bCurrentWeapon;
    var(WeaponSaveRecord) bool bIsActive;
    var(WeaponSaveRecord) EBioItemWeaponRangedType Slot;
};
struct native ME1_EquipmentSaveRecord 
{
    var(ME1_EquipmentSaveRecord) ME1_ItemSaveRecord Item;
    var(ME1_EquipmentSaveRecord) byte Slot;
};
struct native ME1_ItemSaveRecord 
{
    var(ME1_ItemSaveRecord) array<ME1_ItemModSaveRecord> XMods;
    var(ME1_ItemSaveRecord) int ItemId;
    var(ME1_ItemSaveRecord) int Manufacturer;
    var(ME1_ItemSaveRecord) int PlotConditionalID;
    var(ME1_ItemSaveRecord) bool bNewItem;
    var(ME1_ItemSaveRecord) bool bJunkItem;
    var(ME1_ItemSaveRecord) byte sophistication;
};
struct native ME1_ItemModSaveRecord 
{
    var(ME1_ItemModSaveRecord) int ItemId;
    var(ME1_ItemModSaveRecord) int Manufacturer;
    var(ME1_ItemModSaveRecord) int PlotConditionalID;
    var(ME1_ItemModSaveRecord) byte sophistication;
};
struct native ComplexTalentSaveRecord 
{
    var array<int> PrereqTalentIDArray;
    var array<int> PrereqTalentRankArray;
    var int TalentID;
    var int CurrentRank;
    var int MaxRank;
    var int LevelOffset;
    var int LevelsPerRank;
    var int VisualOrder;
};
struct native ME1_SimpleTalentSaveRecord 
{
    var(ME1_SimpleTalentSaveRecord) int TalentID;
    var(ME1_SimpleTalentSaveRecord) int CurrentRank;
};
struct native AppearanceSaveRecord 
{
    var(AppearanceSaveRecord) MorphHeadSaveRecord MorphHead;
    var(AppearanceSaveRecord) int CasualID;
    var(AppearanceSaveRecord) int FullBodyID;
    var(AppearanceSaveRecord) int TorsoID;
    var(AppearanceSaveRecord) int ShoulderID;
    var(AppearanceSaveRecord) int ArmID;
    var(AppearanceSaveRecord) int LegID;
    var(AppearanceSaveRecord) int SpecID;
    var(AppearanceSaveRecord) int Tint1ID;
    var(AppearanceSaveRecord) int Tint2ID;
    var(AppearanceSaveRecord) int Tint3ID;
    var(AppearanceSaveRecord) int PatternID;
    var(AppearanceSaveRecord) int PatternColorID;
    var(AppearanceSaveRecord) int HelmetID;
    var(AppearanceSaveRecord) bool bHasMorphHead;
    var(AppearanceSaveRecord) EPlayerAppearanceType CombatAppearance;
};
struct native MorphHeadSaveRecord 
{
    struct native TextureParameterSaveRecord 
    {
        var(TextureParameterSaveRecord) Name Name;
        var(TextureParameterSaveRecord) Name Texture;
    };
    struct native VectorParameterSaveRecord 
    {
        var(VectorParameterSaveRecord) LinearColor Value;
        var(VectorParameterSaveRecord) Name Name;
    };
    struct native ScalarParameterSaveRecord 
    {
        var(ScalarParameterSaveRecord) Name Name;
        var(ScalarParameterSaveRecord) float Value;
    };
    struct native OffsetBoneSaveRecord 
    {
        var(OffsetBoneSaveRecord) Vector Offset;
        var(OffsetBoneSaveRecord) Name Name;
    };
    struct native MorphFeatureSaveRecord 
    {
        var(MorphFeatureSaveRecord) Name Feature;
        var(MorphFeatureSaveRecord) float Offset;
    };
    var(MorphHeadSaveRecord) array<Name> AccessoryMeshes;
    var(MorphHeadSaveRecord) array<MorphFeatureSaveRecord> MorphFeatures;
    var(MorphHeadSaveRecord) array<OffsetBoneSaveRecord> OffsetBones;
    var(MorphHeadSaveRecord) array<Vector> LOD0Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD1Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD2Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD3Vertices;
    var(MorphHeadSaveRecord) array<ScalarParameterSaveRecord> ScalarParameters;
    var(MorphHeadSaveRecord) array<VectorParameterSaveRecord> VectorParameters;
    var(MorphHeadSaveRecord) array<TextureParameterSaveRecord> TextureParameters;
    var(MorphHeadSaveRecord) Name HairMesh;
};
struct native DoorSaveRecord 
{
    var(DoorSaveRecord) Guid DoorGUID;
    var(DoorSaveRecord) byte CurrentState;
    var(DoorSaveRecord) byte OldState;
};
struct native StreamingStateSaveRecord 
{
    var(StreamingStateSaveRecord) Name Name;
    var(StreamingStateSaveRecord) bool bActive;
};
struct native LevelSaveRecord 
{
    var(LevelSaveRecord) Name LevelName;
    var(LevelSaveRecord) bool bShouldBeLoaded;
    var(LevelSaveRecord) bool bShouldBeVisible;
};
struct native DependentDLCRecord 
{
    var(DependentDLCRecord) init Name Name;
    var(DependentDLCRecord) int ModuleID;
};
struct native GalaxyMapSaveRecord 
{
    struct native PlanetSaveRecord 
    {
        var(PlanetSaveRecord) array<Vector2D> Probes;
        var(PlanetSaveRecord) int PlanetID;
        var(PlanetSaveRecord) bool bVisited;
    };
    var(GalaxyMapSaveRecord) array<PlanetSaveRecord> Planets;
};
struct native ME1PlotTableRecord 
{
    var(ME1PlotTableRecord) array<int> BoolVariables;
    var(ME1PlotTableRecord) array<int> IntVariables;
    var(ME1PlotTableRecord) array<float> FloatVariables;
};
struct native KismetBoolSaveRecord 
{
    var(KismetBoolSaveRecord) Guid BoolGUID;
    var(KismetBoolSaveRecord) bool bValue;
};
struct native PlayerInfoEx 
{
    var string FirstName;
    var string FaceCode;
    var Class<SFXPawn_Player> CharacterClass;
    var BioMorphFace MorphHead;
    var Name BonusTalentClass;
    var bool bIsFemale;
    var EOriginType Origin;
    var ENotorietyType Notoriety;
};
enum ENotorietyType
{
    NotorietyType_None,
    NotorietyType_Survivor,
    NotorietyType_Warhero,
    NotorietyType_Ruthless,
};
enum EOriginType
{
    OriginType_None,
    OriginType_Spacer,
    OriginType_Colony,
    OriginType_Earthborn,
};
enum EHelmetPart
{
    HelmetPart_Helmet,
    HelmetPart_Visor,
    HelmetPart_Breather,
};
enum EPlayerAppearanceType
{
    PlayerAppearanceType_Parts,
    PlayerAppearanceType_Full,
};
enum EEndGameState
{
    EGS_NotFinished,
    EGS_OutInABlazeOfGlory,
    EGS_LivedToFightAgain,
};
const MaleMorphHead = "BIOG_MORPH_FACE.Player_Base_Male";
const FemaleMorphHead = "BIOG_MORPH_FACE.Player_Base_Female";

// Variables
var(SFXSaveGame) PlayerSaveRecord PlayerRecord;
var(SFXSaveGame) PlotTableSaveRecord PlotRecord;
var(SFXSaveGame) ME1PlotTableRecord ME1PlotRecord;
var(SFXSaveGame) init array<DependentDLCRecord> DependentDLC;
var(SFXSaveGame) transient string Filename;
var(SFXSaveGame) transient string DebugName;
var(SFXSaveGame) transient string DisplayName;
var(SFXSaveGame) string characterID;
var(SFXSaveGame) array<LevelSaveRecord> LevelRecords;
var(SFXSaveGame) array<StreamingStateSaveRecord> StreamingRecords;
var(SFXSaveGame) array<KismetBoolSaveRecord> KismetRecords;
var(SFXSaveGame) array<DoorSaveRecord> DoorRecords;
var(SFXSaveGame) array<Guid> PawnRecords;
var(SFXSaveGame) array<HenchmanSaveRecord> HenchmanRecords;
var(SFXSaveGame) GalaxyMapSaveRecord GalaxyMapRecord;
var(SFXSaveGame) SaveTimeStamp TimeStamp;
var(SFXSaveGame) SaveTimeStamp CreatedDate;
var(SFXSaveGame) Vector SaveLocation;
var(SFXSaveGame) Rotator SaveRotation;
var(SFXSaveGame) Name BaseLevelName;
var(SFXSaveGame) transient int SerializedSize;
var(SFXSaveGame) transient int FileVersion;
var(SFXSaveGame) float SecondsPlayed;
var(SFXSaveGame) int Disc;
var(SFXSaveGame) int EndGameState;
var(SFXSaveGame) int CurrentLoadingTip;
var(SFXSaveGame) transient bool bIsValid;
var(SFXSaveGame) transient bool bIsGamerProfile;
var(SFXSaveGame) EDifficultyOptions Difficulty;

// Functions
public final function Class<SFXPower> LoadPower(string PowerClassName)
{
    local Class<SFXPower> PowerClass;
    
    PowerClass = Class<SFXPower>(FindObject(PowerClassName, Class'Class'));
    if (PowerClass == None)
    {
        if (Class'SFXEngine'.static.IsSeekFreeObjectSupported(PowerClassName))
        {
            PowerClass = Class<SFXPower>(Class'SFXEngine'.static.LoadSeekFreeObject(PowerClassName, Class'Class'));
        }
    }
    return PowerClass;
}
public final function LoadHotKeys(BioPlayerController PC, out array<HotKeySaveRecord> Records)
{
    local int Idx;
    
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        for (Idx = 0; Idx < 8 && Idx < Records.Length; Idx++)
        {
            PC.m_aHotKeyDefines[Idx].nmPawn = Records[Idx].PawnName;
            PC.m_aHotKeyDefines[Idx].nPowerID = Records[Idx].PowerID;
        }
    }
}
public final function LoadWeapons(SFXPawn_Player Player, out array<WeaponSaveRecord> Records)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local int Idx;
    local int Idx2;
    local SFXPower Power;
    local BioPowerScript PowerScript;
    local int HWAmmoUsedCount;
    
    Player.CreateWeapons(Player.Loadout);
    InvManager = SFXInventoryManager(Player.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            Idx = Records.Find('WeaponClassName', Weapon.Class.Name);
            if (Idx != -1)
            {
                HWAmmoUsedCount = Records[Idx].AmmoUsedCount;
                if (!Class'ESM_LE2'.default.LoadRequested)
                {
                    Idx2 = Records.Find('WeaponClassName', Name("ESM_" $ Weapon.Class.Name));
                    if (Idx2 != -1)
                    {
                        HWAmmoUsedCount = Records[Idx2].AmmoUsedCount;
                    }
                    else
                    {
                        Idx2 = Records.Find('WeaponClassName', 'ESM_None');
                        if (Idx2 != -1)
                        {
                            HWAmmoUsedCount = 0;
                        }
                    }
                }
                if (float(HWAmmoUsedCount) <= Weapon.GetMagazineSize())
                {
                    Weapon.AmmoUsedCount = float(HWAmmoUsedCount);
                }
                else
                {
                    Weapon.AmmoUsedCount = Weapon.GetMagazineSize();
                }
                Weapon.CurrentSpareAmmo = Records[Idx].TotalAmmo;
                if (Records[Idx].bLastWeapon)
                {
                    Player.WeaponOnDeck = Weapon;
                }
                if (Records[Idx].bCurrentWeapon)
                {
                    InvManager.CurrentWeaponSelection = Weapon.Class;
                }
                Weapon.AmmoPowerName = Records[Idx].AmmoPowerName;
                if (Weapon.AmmoPowerName != 'None')
                {
                    Power = Player.PowerManager.GetPower(Weapon.AmmoPowerName);
                    if (Power != None)
                    {
                        PowerScript = Power.GetPowerScript();
                        if (PowerScript != None)
                        {
                            PowerScript.ReloadAmmoPower(Player, Weapon);
                        }
                    }
                }
            }
        }
        Class'ESM_LE2'.default.LoadRequested = FALSE;
    }
}
public final function LoadPowers(SFXPawn Pawn, out array<PowerSaveRecord> Records)
{
    local array<PowerSaveInfo> Powers;
    local int Idx;
    local SFXPowerManager PowerMan;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        Powers.Length = Records.Length;
        for (Idx = 0; Idx < Records.Length; Idx++)
        {
            Powers[Idx].PowerName = Records[Idx].PowerName;
            Powers[Idx].CurrentRank = Records[Idx].CurrentRank;
            Powers[Idx].PowerClassName = Records[Idx].PowerClassName;
            Powers[Idx].WheelDisplayIndex = Records[Idx].WheelDisplayIndex;
        }
        PowerMan.LoadPowers(Powers);
    }
}
public static final function BioMorphFace LoadMorphHead(out PlayerSaveRecord ThePlayerRecord)
{
    local BioMorphFace MorphHead;
    local MorphHeadSaveRecord Record;
    local string PackageName;
    local int Idx;
    local MorphFeature Feature;
    local OffsetBonePos Offset;
    local ScalarParameter ScalarParam;
    local ColorParameter ColorParam;
    local TextureParameter TextureParam;
    local array<int> BuffersToRefresh;
    
    if (ThePlayerRecord.Appearance.bHasMorphHead)
    {
        Record = ThePlayerRecord.Appearance.MorphHead;
        PackageName = Left(ThePlayerRecord.bIsFemale ? "BIOG_MORPH_FACE.Player_Base_Female" : "BIOG_MORPH_FACE.Player_Base_Male", InStr(ThePlayerRecord.bIsFemale ? "BIOG_MORPH_FACE.Player_Base_Female" : "BIOG_MORPH_FACE.Player_Base_Male", ".", FALSE, , ));
        Class'SFXGame'.static.LoadPackage(PackageName);
        MorphHead = BioMorphFace(FindObject(ThePlayerRecord.bIsFemale ? "BIOG_MORPH_FACE.Player_Base_Female" : "BIOG_MORPH_FACE.Player_Base_Male", Class'BioMorphFace'));
        if (MorphHead != None)
        {
            if (PathName(MorphHead.m_oHairMesh) != string(Record.HairMesh))
            {
                MorphHead.m_oHairMesh = SkeletalMesh(DynamicLoadObject(string(Record.HairMesh), Class'SkeletalMesh'));
            }
            if (MorphHead.m_oOtherMeshes.Length != Record.AccessoryMeshes.Length)
            {
                MorphHead.m_oOtherMeshes.Length = Record.AccessoryMeshes.Length;
                for (Idx = 0; Idx < Record.AccessoryMeshes.Length; Idx++)
                {
                    MorphHead.m_oOtherMeshes[Idx] = SkeletalMesh(DynamicLoadObject(string(Record.AccessoryMeshes[Idx]), Class'SkeletalMesh'));
                }
            }
            MorphHead.m_aMorphFeatures.Length = Record.MorphFeatures.Length;
            for (Idx = 0; Idx < Record.MorphFeatures.Length; Idx++)
            {
                Feature.sFeatureName = Record.MorphFeatures[Idx].Feature;
                Feature.Offset = Record.MorphFeatures[Idx].Offset;
                MorphHead.m_aMorphFeatures[Idx] = Feature;
            }
            MorphHead.m_aFinalSkeleton.Length = Record.OffsetBones.Length;
            for (Idx = 0; Idx < Record.OffsetBones.Length; Idx++)
            {
                Offset.nName = Record.OffsetBones[Idx].Name;
                Offset.vPos = Record.OffsetBones[Idx].Offset;
                MorphHead.m_aFinalSkeleton[Idx] = Offset;
            }
            for (Idx = 0; Idx < Record.LOD0Vertices.Length; Idx++)
            {
                MorphHead.SetPosition(0, Idx, Record.LOD0Vertices[Idx]);
            }
            BuffersToRefresh.AddItem(0);
            MorphHead.RefreshBuffers(BuffersToRefresh);
            MorphHead.m_oMaterialOverrides.m_aScalarOverrides.Length = Record.ScalarParameters.Length;
            for (Idx = 0; Idx < Record.ScalarParameters.Length; Idx++)
            {
                ScalarParam.nName = Record.ScalarParameters[Idx].Name;
                ScalarParam.sValue = Record.ScalarParameters[Idx].Value;
                MorphHead.m_oMaterialOverrides.m_aScalarOverrides[Idx] = ScalarParam;
            }
            MorphHead.m_oMaterialOverrides.m_aColorOverrides.Length = Record.VectorParameters.Length;
            for (Idx = 0; Idx < Record.VectorParameters.Length; Idx++)
            {
                ColorParam.nName = Record.VectorParameters[Idx].Name;
                ColorParam.cValue = Record.VectorParameters[Idx].Value;
                MorphHead.m_oMaterialOverrides.m_aColorOverrides[Idx] = ColorParam;
            }
            MorphHead.m_oMaterialOverrides.m_aTextureOverrides.Length = Record.TextureParameters.Length;
            for (Idx = 0; Idx < Record.TextureParameters.Length; Idx++)
            {
                TextureParam.nName = Record.TextureParameters[Idx].Name;
                TextureParam.m_pTexture = Texture2D(DynamicLoadObject(string(Record.TextureParameters[Idx].Texture), Class'Texture2D'));
                MorphHead.m_oMaterialOverrides.m_aTextureOverrides[Idx] = TextureParam;
            }
            return MorphHead;
        }
    }
    return None;
}
public final function LoadAppearance(SFXPawn_Player Player, out PlayerSaveRecord Record)
{
    local SFXEngine Engine;
    local bool IconicShepardOnly;
    
    IconicShepardOnly = FALSE;
    Engine = Class'SFXEngine'.static.GetEngine();
    if (Engine != None && Engine.DebugUseIconicShepard)
    {
        IconicShepardOnly = TRUE;
        Engine.DebugUseIconicShepard = FALSE;
    }
    Player.CombatAppearance = Record.Appearance.CombatAppearance;
    Player.CasualID = Record.Appearance.CasualID;
    Player.FullBodyID = Record.Appearance.FullBodyID;
    Player.TorsoID = Record.Appearance.TorsoID;
    Player.ShoulderID = Record.Appearance.ShoulderID;
    Player.ArmID = Record.Appearance.ArmID;
    Player.LegID = Record.Appearance.LegID;
    Player.SpecID = Record.Appearance.SpecID;
    Player.Tint1ID = Record.Appearance.Tint1ID;
    Player.Tint2ID = Record.Appearance.Tint2ID;
    Player.PatternID = Record.Appearance.PatternID;
    Player.PatternColorID = Record.Appearance.PatternColorID;
    Player.HelmetID = Record.Appearance.HelmetID;
    if (Record.Appearance.bHasMorphHead && IconicShepardOnly == FALSE)
    {
        Player.MorphHead = LoadMorphHead(Record);
    }
}
public final event function LoadHenchman(SFXPawn_Henchman Hench)
{
    local SFXEngine Engine;
    local int Idx;
    local array<PowerSaveRecord> Powers;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    Idx = Engine.HenchmanRecords.Find('Tag', Hench.Tag);
    if (Idx >= 0)
    {
        Powers = HenchmanRecords[Idx].Powers;
        LoadPowers(Hench, Powers);
        Hench.TalentPoints = Engine.HenchmanRecords[Idx].TalentPoints;
        Hench.CharacterLevel = Engine.HenchmanRecords[Idx].CharacterLevel;
        Hench.CreateWeapons(Hench.Loadout);
        Hench.m_nmMappedPower = Engine.HenchmanRecords[Idx].MappedPower;
    }
}
public final event function LoadPlayer(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXPawn_Player Player;
    local SFXInventoryManager InvMan;
    local SFXEngine Engine;
    local BioPlayerInput Input;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Engine = SFXEngine(Outer);
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            Engine = SFXEngine(Outer);
            if (Engine != None && Engine.bPlayerLoadPosition)
            {
                Player.bCollideWorld = FALSE;
                Player.SetLocation(SaveLocation + vect(0.0, 0.0, 2.0));
                Player.bCollideWorld = TRUE;
                Player.SetRotation(SaveRotation);
                Player.Controller.SetRotation(SaveRotation);
                Engine.bPlayerLoadPosition = FALSE;
            }
            Player.CharacterLevel = PlayerRecord.Level;
            Player.TotalXP = PlayerRecord.CurrentXP;
            Player.FirstName = PlayerRecord.FirstName;
            Player.Origin = PlayerRecord.Origin;
            Player.Notoriety = PlayerRecord.Notoriety;
            Player.TalentPoints = PlayerRecord.TalentPoints;
            Player.FaceCode = PlayerRecord.FaceCode;
            if (PlayerController(Player.Controller) != None)
            {
                Input = BioPlayerInput(PlayerController(Player.Controller).PlayerInput);
                if (Input != None)
                {
                    Input.m_nmMappedPower = PlayerRecord.MappedPower1;
                    Input.m_nmMappedPower2 = PlayerRecord.MappedPower2;
                    Input.m_nmMappedPower3 = PlayerRecord.MappedPower3;
                }
            }
            LoadAppearance(Player, PlayerRecord);
            LoadPowers(Player, PlayerRecord.Powers);
            if (BioPlayerController(Player.Controller) != None)
            {
                LoadHotKeys(BioPlayerController(Player.Controller), PlayerRecord.HotKeys);
            }
            InvMan = SFXInventoryManager(Player.InvManager);
            if (InvMan != None)
            {
                LoadWeapons(Player, PlayerRecord.Weapons);
                InvMan.Credits = PlayerRecord.Credits;
                InvMan.Medigel = PlayerRecord.Medigel;
                InvMan.Eezo = PlayerRecord.Eezo;
                InvMan.Iridium = PlayerRecord.Iridium;
                InvMan.Palladium = PlayerRecord.Palladium;
                InvMan.Platinum = PlayerRecord.Platinum;
                InvMan.Probes = PlayerRecord.Probes;
                InvMan.CurrentFuel = PlayerRecord.CurrentFuel;
            }
            Player.UpdateAppearance();
            Class'SFXTelemetry'.static.SetContextPlayerLevel(PlayerRecord.Level);
            Engine.ME1ImportBonuses.ImportedME1Level = PlayerRecord.ME1ImportBonuses.ImportedME1Level;
            Engine.ME1ImportBonuses.StartingME2Level = PlayerRecord.ME1ImportBonuses.StartingME2Level;
            Engine.ME1ImportBonuses.BonusXP = PlayerRecord.ME1ImportBonuses.BonusXP;
            Engine.ME1ImportBonuses.BonusCredits = PlayerRecord.ME1ImportBonuses.BonusCredits;
            Engine.ME1ImportBonuses.BonusResources = PlayerRecord.ME1ImportBonuses.BonusResources;
            Engine.ME1ImportBonuses.BonusParagon = PlayerRecord.ME1ImportBonuses.BonusParagon;
            Engine.ME1ImportBonuses.BonusRenegade = PlayerRecord.ME1ImportBonuses.BonusRenegade;
        }
    }
}
public final function GetSpawnData(out int IsFemale, out Class<SFXPawn_Player> CharacterClass, out string FirstName, out EOriginType Origin, out ENotorietyType Notoriety)
{
    IsFemale = int(PlayerRecord.bIsFemale);
    CharacterClass = PlayerRecord.PlayerClass;
    FirstName = PlayerRecord.FirstName;
    Origin = PlayerRecord.Origin;
    Notoriety = PlayerRecord.Notoriety;
}
public final function SaveHotKeys(BioPlayerController PC, out array<HotKeySaveRecord> Records)
{
    local int Idx;
    
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        Records.Length = 8;
        for (Idx = 0; Idx < 8; Idx++)
        {
            Records[Idx].PawnName = PC.m_aHotKeyDefines[Idx].nmPawn;
            Records[Idx].PowerID = PC.m_aHotKeyDefines[Idx].nPowerID;
        }
    }
}
public final function SaveWeapons(SFXPawn_Player Player, out array<WeaponSaveRecord> Records)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local WeaponSaveRecord SaveInfo;
    
    InvManager = SFXInventoryManager(Player.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            SaveInfo.WeaponClassName = Weapon.Class.Name;
            SaveInfo.AmmoUsedCount = int(Weapon.AmmoUsedCount);
            SaveInfo.TotalAmmo = int(Weapon.GetCurrentSpareAmmo());
            SaveInfo.bLastWeapon = FALSE;
            if (Player.WeaponOnDeck == Weapon)
            {
                SaveInfo.bLastWeapon = TRUE;
            }
            SaveInfo.bCurrentWeapon = FALSE;
            if (InvManager.CurrentWeaponSelection == Weapon.Class)
            {
                SaveInfo.bCurrentWeapon = TRUE;
            }
            SaveInfo.AmmoPowerName = Weapon.AmmoPowerName;
            Records.AddItem(SaveInfo);
        }
        if (Class'SFXEngine'.static.GetEngine().GetCurrentSaveDescriptor().Type == ESFXSaveGameType.SaveGameType_Auto)
        {
            SaveInfo.WeaponClassName = Name("ESM_" $ Class'ESM_LE2'.default.HWWeaponClass);
            SaveInfo.AmmoUsedCount = Class'ESM_LE2'.default.HWAmmoUsedCount;
            Records.AddItem(SaveInfo);
        }
    }
}
public final function SavePowers(SFXPawn Pawn, out array<PowerSaveRecord> Records)
{
    local array<PowerSaveInfo> Powers;
    local int Idx;
    local SFXPowerManager PowerMan;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        PowerMan.SavePowers(Powers);
        Records.Length = Powers.Length;
        for (Idx = 0; Idx < Powers.Length; Idx++)
        {
            Records[Idx].PowerName = Powers[Idx].PowerName;
            Records[Idx].CurrentRank = Powers[Idx].CurrentRank;
            Records[Idx].PowerClassName = Powers[Idx].PowerClassName;
            Records[Idx].WheelDisplayIndex = Powers[Idx].WheelDisplayIndex;
        }
    }
}
public final function bool SaveMorphHead(BioMorphFace Morph, out MorphHeadSaveRecord Record)
{
    local int Idx;
    local BioMaterialOverride MatOverride;
    
    if (Morph != None)
    {
        Record.HairMesh = Name(PathName(Morph.m_oHairMesh));
        Record.AccessoryMeshes.Length = Morph.m_oOtherMeshes.Length;
        for (Idx = 0; Idx < Morph.m_oOtherMeshes.Length; Idx++)
        {
            Record.AccessoryMeshes[Idx] = Name(PathName(Morph.m_oOtherMeshes[Idx]));
        }
        Record.MorphFeatures.Length = Morph.m_aMorphFeatures.Length;
        for (Idx = 0; Idx < Morph.m_aMorphFeatures.Length; Idx++)
        {
            Record.MorphFeatures[Idx].Feature = Morph.m_aMorphFeatures[Idx].sFeatureName;
            Record.MorphFeatures[Idx].Offset = Morph.m_aMorphFeatures[Idx].Offset;
        }
        Record.OffsetBones.Length = Morph.m_aFinalSkeleton.Length;
        for (Idx = 0; Idx < Morph.m_aFinalSkeleton.Length; Idx++)
        {
            Record.OffsetBones[Idx].Name = Morph.m_aFinalSkeleton[Idx].nName;
            Record.OffsetBones[Idx].Offset = Morph.m_aFinalSkeleton[Idx].vPos;
        }
        Record.LOD0Vertices.Length = Morph.GetNumVerts(0);
        for (Idx = 0; Idx < Morph.GetNumVerts(0); Idx++)
        {
            Record.LOD0Vertices[Idx] = Morph.GetPosition(0, Idx);
        }
        MatOverride = Morph.m_oMaterialOverrides;
        if (MatOverride != None)
        {
            Record.ScalarParameters.Length = MatOverride.m_aScalarOverrides.Length;
            for (Idx = 0; Idx < MatOverride.m_aScalarOverrides.Length; Idx++)
            {
                Record.ScalarParameters[Idx].Name = MatOverride.m_aScalarOverrides[Idx].nName;
                Record.ScalarParameters[Idx].Value = MatOverride.m_aScalarOverrides[Idx].sValue;
            }
            Record.VectorParameters.Length = MatOverride.m_aColorOverrides.Length;
            for (Idx = 0; Idx < MatOverride.m_aColorOverrides.Length; Idx++)
            {
                Record.VectorParameters[Idx].Name = MatOverride.m_aColorOverrides[Idx].nName;
                Record.VectorParameters[Idx].Value = MatOverride.m_aColorOverrides[Idx].cValue;
            }
            Record.TextureParameters.Length = MatOverride.m_aTextureOverrides.Length;
            for (Idx = 0; Idx < MatOverride.m_aTextureOverrides.Length; Idx++)
            {
                Record.TextureParameters[Idx].Name = MatOverride.m_aTextureOverrides[Idx].nName;
                Record.TextureParameters[Idx].Texture = Name(PathName(MatOverride.m_aTextureOverrides[Idx].m_pTexture));
            }
        }
        return TRUE;
    }
    return FALSE;
}
public final function SaveAppearance(SFXPawn_Player Player, out AppearanceSaveRecord Record)
{
    Record.CombatAppearance = Player.CombatAppearance;
    Record.CasualID = Player.CasualID;
    Record.FullBodyID = Player.FullBodyID;
    Record.TorsoID = Player.TorsoID;
    Record.ShoulderID = Player.ShoulderID;
    Record.ArmID = Player.ArmID;
    Record.LegID = Player.LegID;
    Record.SpecID = Player.SpecID;
    Record.Tint1ID = Player.Tint1ID;
    Record.Tint2ID = Player.Tint2ID;
    Record.Tint3ID = 0;
    Record.PatternID = Player.PatternID;
    Record.PatternColorID = Player.PatternColorID;
    Record.HelmetID = Player.HelmetID;
    Record.bHasMorphHead = FALSE;
    if (SaveMorphHead(Player.MorphHead, Record.MorphHead))
    {
        Record.bHasMorphHead = TRUE;
    }
}
public final event function SaveHenchmen(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXPawn_Player Player;
    local SFXEngine Engine;
    local BioBaseSquad Squad;
    local int Idx;
    local int HenchIdx;
    local SFXPawn_Henchman Hench;
    local HenchmanSaveRecord SaveInfo;
    local array<PowerSaveRecord> Powers;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            HenchmanRecords = Engine.HenchmanRecords;
            Squad = Player.Squad;
            if (Squad != None)
            {
                for (Idx = 0; Idx < Squad.GetSquadSize(); Idx++)
                {
                    Hench = SFXPawn_Henchman(Squad.GetMember(Idx));
                    if (Hench != None)
                    {
                        HenchIdx = HenchmanRecords.Find('Tag', Hench.Tag);
                        if (HenchIdx != -1)
                        {
                            Powers = HenchmanRecords[HenchIdx].Powers;
                            SavePowers(Hench, Powers);
                            HenchmanRecords[HenchIdx].Powers = Powers;
                            HenchmanRecords[HenchIdx].TalentPoints = Hench.TalentPoints;
                            HenchmanRecords[HenchIdx].CharacterLevel = Hench.CharacterLevel;
                            HenchmanRecords[HenchIdx].MappedPower = Hench.m_nmMappedPower;
                            continue;
                        }
                        SaveInfo.Tag = Hench.Tag;
                        SavePowers(Hench, SaveInfo.Powers);
                        SaveInfo.TalentPoints = Hench.TalentPoints;
                        SaveInfo.CharacterLevel = Hench.CharacterLevel;
                        Class'SFXPawn_Henchman'.static.GetDefaultLoadout(Hench.Tag, SaveInfo.LoadoutWeapons);
                        SaveInfo.MappedPower = Hench.m_nmMappedPower;
                        HenchmanRecords.AddItem(SaveInfo);
                    }
                }
            }
            Engine.HenchmanRecords = HenchmanRecords;
        }
    }
}
public final function EnsureHenchmanRecordExists(SFXPawn_Henchman Hench)
{
    local int HenchIdx;
    local HenchmanSaveRecord SaveInfo;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    HenchIdx = Engine.HenchmanRecords.Find('Tag', Hench.Tag);
    if (HenchIdx == -1)
    {
        SaveInfo.Tag = Hench.Tag;
        SavePowers(Hench, SaveInfo.Powers);
        SaveInfo.TalentPoints = Hench.TalentPoints;
        SaveInfo.CharacterLevel = Hench.CharacterLevel;
        Class'SFXPawn_Henchman'.static.GetDefaultLoadout(Hench.Tag, SaveInfo.LoadoutWeapons);
        SaveInfo.MappedPower = Hench.m_nmMappedPower;
        Engine.HenchmanRecords.AddItem(SaveInfo);
    }
}
public final event function SavePlayer(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXEngine Engine;
    local SFXPawn_Player Player;
    local SFXInventoryManager InvMan;
    local BioPlayerInput Input;
    local int Idx;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Engine = SFXEngine(Outer);
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            bIsValid = TRUE;
            SaveLocation = Player.Location;
            if (Player.bIsCrouched)
            {
                SaveLocation.Z += Class'SFXPawn_Player'.default.CylinderComponent.CollisionHeight - Player.CylinderComponent.CollisionHeight;
            }
            SaveRotation = Player.Rotation;
            PlayerRecord.bIsFemale = Player.bIsFemale;
            PlayerRecord.PlayerClassName = Name(PathName(Player.Class));
            PlayerRecord.PlayerClass = Player.Class;
            PlayerRecord.srClassFriendlyName = Player.PlayerClass.srClassName;
            PlayerRecord.Level = Player.CharacterLevel;
            PlayerRecord.CurrentXP = Player.TotalXP;
            PlayerRecord.FirstName = Player.FirstName;
            PlayerRecord.LastName = int(Class'SFXPawn_Player'.static.GetLastNameStringRef());
            PlayerRecord.Origin = Player.Origin;
            PlayerRecord.Notoriety = Player.Notoriety;
            PlayerRecord.TalentPoints = Player.TalentPoints;
            PlayerRecord.FaceCode = Player.FaceCode;
            for (Idx = 0; Idx < 6; Idx++)
            {
                PlayerRecord.LoadoutWeapons[Idx] = Engine.PlayerLoadoutWeapons[Idx];
            }
            if (PlayerController(Player.Controller) != None)
            {
                Input = BioPlayerInput(PlayerController(Player.Controller).PlayerInput);
                if (Input != None)
                {
                    PlayerRecord.MappedPower1 = Input.m_nmMappedPower;
                    PlayerRecord.MappedPower2 = Input.m_nmMappedPower2;
                    PlayerRecord.MappedPower3 = Input.m_nmMappedPower3;
                }
            }
            SaveAppearance(Player, PlayerRecord.Appearance);
            SavePowers(Player, PlayerRecord.Powers);
            SaveWeapons(Player, PlayerRecord.Weapons);
            if (BioPlayerController(Player.Controller) != None)
            {
                SaveHotKeys(BioPlayerController(Player.Controller), PlayerRecord.HotKeys);
            }
            InvMan = SFXInventoryManager(Player.InvManager);
            if (InvMan != None)
            {
                PlayerRecord.Credits = InvMan.Credits;
                PlayerRecord.Medigel = InvMan.Medigel;
                PlayerRecord.Eezo = InvMan.Eezo;
                PlayerRecord.Iridium = InvMan.Iridium;
                PlayerRecord.Palladium = InvMan.Palladium;
                PlayerRecord.Platinum = InvMan.Platinum;
                PlayerRecord.Probes = InvMan.Probes;
                PlayerRecord.CurrentFuel = InvMan.CurrentFuel;
            }
            PlayerRecord.ME1ImportBonuses.ImportedME1Level = Engine.ME1ImportBonuses.ImportedME1Level;
            PlayerRecord.ME1ImportBonuses.StartingME2Level = Engine.ME1ImportBonuses.StartingME2Level;
            PlayerRecord.ME1ImportBonuses.BonusXP = Engine.ME1ImportBonuses.BonusXP;
            PlayerRecord.ME1ImportBonuses.BonusCredits = Engine.ME1ImportBonuses.BonusCredits;
            PlayerRecord.ME1ImportBonuses.BonusResources = Engine.ME1ImportBonuses.BonusResources;
            PlayerRecord.ME1ImportBonuses.BonusParagon = Engine.ME1ImportBonuses.BonusParagon;
            PlayerRecord.ME1ImportBonuses.BonusRenegade = Engine.ME1ImportBonuses.BonusRenegade;
        }
    }
}
public final function bool GetPlayerRecord(out PlayerSaveRecord Record)
{
    Record = PlayerRecord;
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Difficulty = EDifficultyOptions.DO_Level2
}