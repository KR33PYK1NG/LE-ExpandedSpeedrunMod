Class SFXEngine extends GameEngine
    native
    transient
    config(Engine);

// Types
struct native PackageRemapInfo 
{
    var Name PackageName;
    var Name SeekFreePackageName;
};
struct native DynamicLoadInfo 
{
    var string ObjectName;
    var Name SeekFreePackageName;
    var transient Object CachedObjectHandle;
    var transient Object LoadedLinkerRoot;
};
enum EAsyncLoadStatus
{
    ASYNC_LOAD_ERROR,
    ASYNC_LOAD_STARTED,
    ASYNC_LOAD_INPROGRESS,
    ASYNC_LOAD_COMLETE,
};
struct native BlazeDataStore 
{
    var(BlazeDataStore) array<byte> LoginInfo;
    var(BlazeDataStore) array<byte> PersonaID;
    var(BlazeDataStore) int DaysSinceRegistration;
    var(BlazeDataStore) bool bNucleusRefused;
    var(BlazeDataStore) bool bNucleusSuccessful;
    var(BlazeDataStore) bool bCerberusRefused;
    var(BlazeDataStore) bool bAutoLogin;
    var(BlazeDataStore) bool bDirty;
    var(BlazeDataStore) bool bPS3_RedeemedProductCode;
    
    structdefaultproperties
    {
        LoginInfo = ()
        PersonaID = ()
    }
};
struct native unkstructflag SFXCareerCacheEntry 
{
    var init string Career;
    var init string FirstName;
    var init stringref ClassName;
    var init int SaveTypes;
    var init EOriginType Origin;
    var init ENotorietyType Notoriety;
    var init EEndGameState EndGameState;
};
struct native unkstructflag SFXSaveGameCommandEventArgs 
{
    var init SFXSaveDescriptor Descriptor;
    var init array<SFXCareerDescriptor> Careers;
    var init array<string> CorruptedCareers;
    var init int AdditionalFreeBytesNeeded;
    var init int TotalFreeBytes;
    var init int PreparedSaveSize;
    var init bool bSuccess;
    var init bool bRetry;
    var init bool bPause;
    var init bool bNeedsFreeSpace;
    var init bool bTotalFreeBytesSet;
    var init bool bPreparedSaveSizeSet;
    var init ESFXSaveGameAction Action;
};
struct native unkstructflag SFXCareerDescriptor 
{
    var init string Career;
    var init array<SFXSavePair> Saves;
    var init array<SFXSaveDescriptor> CorruptedSaves;
};
struct native unkstructflag SFXSavePair 
{
    var init SFXSaveDescriptor Descriptor;
    var init SFXSaveGame Save;
};
struct native unkstructflag SFXSaveDescriptor 
{
    var init string Career;
    var init string SaveName;
    var init int Index;
    var init ESFXSaveGameType Type;
    
    structdefaultproperties
    {
        Index = -1
    }
};
enum ESFXSaveGameType
{
    SaveGameType_Manual,
    SaveGameType_Quick,
    SaveGameType_Auto,
    SaveGameType_Chapter,
    SaveGameType_Legacy,
};
enum ESFXSaveGameAction
{
    SaveGame_DoNothing,
    SaveGame_Load,
    SaveGame_Save,
    SaveGame_Delete,
    SaveGame_CreateCareer,
    SaveGame_DeleteCareer,
    SaveGame_EnumerateCareers,
    SaveGame_EnumerateSaves,
    SaveGame_QueryFreeSpace,
    SaveGame_PrepareSave,
    SaveGame_DeletePreparedSave,
};
const EncodedSaveDescriptorMultiplier = 1000000;

// Variables
var transient UniqueNetId m_oInitialPlayerID;
var transient UniqueNetId m_oProfilePlayerID;
var config transient PlayerInfoEx DefaultPlayer;
var transient PlayerInfoEx NewPlayer;
var(SFXEngine) BlazeDataStore BlazeCache;
var(SFXEngine) array<Guid> DeadPawnList;
var(SFXEngine) array<KismetBoolSaveRecord> SavedKismetList;
var(SFXEngine) array<HenchmanSaveRecord> HenchmanRecords;
var(SFXEngine) array<DoorSaveRecord> SavedDoorList;
var(SFXEngine) array<string> CorruptedCareers;
var(SFXEngine) array<SFXCareerCacheEntry> CareerCache;
var(SFXEngine) delegate<OnResumeGameComplete> ResumeGameCompleteDelegate;
var const config array<DynamicLoadInfo> DynamicLoadMapping;
var const config array<PackageRemapInfo> DynamicLoadPackageRemapping;
var transient array<int> AsyncLoadingMapping;
var delegate<SFXSaveCommandCallback> __SFXSaveCommandCallback__Delegate;
var delegate<OnResumeGameComplete> __OnResumeGameComplete__Delegate;
var Name PlayerLoadoutWeapons[6];
var(SFXEngine) ME1ImportBonusSaveRecord ME1ImportBonuses;
var(SFXEngine) SFXSaveGame CurrentSaveGame;
var(SFXEngine) SFXLegacyData ME1ImportData;
var(SFXEngine) SFXSaveGame ME2ImportSaveGame;
var transient SFXTelemetry Telemetry;
var transient Name m_DesiredStartPoint;
var(SFXEngine) transient export SFXLoadMovieManager LoadMovieManager;
var(SFXEngine) float LastSaveTime;
var(SFXEngine) float LastSecondsPlayed;
var(SFXEngine) int CurrentUserID;
var(SFXEngine) int CurrentDeviceID;
var(SFXEngine) int CurrentLoadingTip;
var(SFXEngine) stringref AutoSaveInsufficientSpaceTextPS3;
var(SFXEngine) stringref InsufficentSpaceAcknowledgedText;
var(SFXEngine) transient stringref CorruptCareerWarningText;
var(SFXEngine) transient stringref ConfirmDeleteCorruptText;
var(SFXEngine) transient stringref CancelDeleteCorruptText;
var transient float LastCantContinueTime;
var transient stringref srCantContinueErrorMessage;
var(SFXEngine) bool bCanWriteSaveToStorage;
var transient bool bPendingSaveProfile;
var transient bool bPendingDisableAutoSave;
var transient bool bFlushInputRequested;
var(SFXEngine) bool bPlayerNeedsLoad;
var(SFXEngine) bool bPlayerLoadPosition;
var transient bool m_bRenderingSuspended;
var transient bool m_bInLoad;
var transient bool m_bProfileInitialized;
var transient bool m_UseDesiredStartPoint;
var transient bool bNewPlayer;
var transient bool bStartedGame;
var transient bool IsDebuggingCharactionCreation;
var transient bool DebugCharacterIsMale;
var transient bool DebugUseIconicShepard;
var(SFXEngine) transient byte PendingModeToRemove;

// Functions
private final event function ClearInitialTelemetryHandler()
{
    local OnlinePlayerInterface PlayerInterface;
    
    if (OnlineSubsystem != None)
    {
        PlayerInterface = OnlineSubsystem.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.ClearReadProfileSettingsCompleteDelegate(0, SendTelemetryOnProfileReadComplete);
        }
    }
}
private final event function AddInitialTelemetryHandler()
{
    local OnlinePlayerInterface PlayerInterface;
    
    if (OnlineSubsystem != None)
    {
        PlayerInterface = OnlineSubsystem.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.AddReadProfileSettingsCompleteDelegate(0, SendTelemetryOnProfileReadComplete);
        }
    }
}
public native function SendTelemetryOnProfileReadComplete(byte LocalUserNum, bool bWasSuccessful);

public native function FlushIOHandles();

public native function BioShowDebugMessageBox(string sMessage);

public native function bool FindCurrentSaveDevice();

public final native function bool IsCurrentDeviceValid();

public final native function ForceGUIUpdate();

public final native function float GetCurrentTime();

public final native function float GetPlayTimeSeconds();

public final native function LoadPlayer();

public final native function int GetCurrentDevice();

public final native function UpdateCurrentDevice(int DeviceID);

private final function SlowResumeGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (ResumeGameCompleteDelegate != None)
    {
        ResumeGameCompleteDelegate(Args.bSuccess);
        ResumeGameCompleteDelegate = None;
    }
}
private final function FastResumeGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess)
    {
        SlowResumeGameCallback(Args);
    }
    else if (TravelURL == "")
    {
        QueueSaveGameCommand(1, , SlowResumeGameCallback);
    }
    else
    {
        SlowResumeGameCallback(Args);
    }
}
public final function ResumeGame(optional delegate<OnResumeGameComplete> Callback)
{
    local SFXSaveDescriptor Descriptor;
    
    if (TravelURL == "")
    {
        ResumeGameCompleteDelegate = Callback;
        Descriptor = GetCurrentSaveDescriptor();
        Class'ESM_LE2'.default.LoadRequested = TRUE;
        QueueSaveGameCommand(1, Descriptor, FastResumeGameCallback);
    }
    else if (Callback != None)
    {
        Callback(FALSE);
    }
}
private final function SFXProfileSettings GetProfileSettings()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_OnlinePlayerData OnlinePlayerData;
    
    if (GamePlayers.Length > 0)
    {
        LP = GamePlayers[0];
        if (LP != None)
        {
            DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
            if (DataStoreManager != None)
            {
                OnlinePlayerData = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
                if (OnlinePlayerData != None)
                {
                    return SFXProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
                }
            }
        }
    }
    return None;
}
private final function MassEffectGuiManager GetScaleFormManager()
{
    local LocalPlayer LP;
    
    if (GamePlayers.Length > 0)
    {
        LP = GamePlayers[0];
        if (LP != None)
        {
            return MassEffectGuiManager(LP.Outer.GameViewport.m_pScaleFormManager);
        }
    }
    return None;
}
private final function HandleNoFreeSpacePS3Callback(bool bAPressed, int context);

private final function HandleNoFreeSpacePS3(ESFXSaveGameType Type, int AdditionalFreeBytesNeeded)
{
    local SFXProfileSettings ProfileSettings;
    local BioMessageBoxOptionalParams Params;
    local MassEffectGuiManager GuiMan;
    local string InsufficientSpaceTextWithSize;
    
    if (Type == ESFXSaveGameType.SaveGameType_Auto)
    {
        Params.srAText = InsufficentSpaceAcknowledgedText;
        Params.srBText = $0;
        Params.bModal = TRUE;
        Params.bForcePlayersOnly = TRUE;
        Params.bNoFade = TRUE;
        SetCustomToken(1, string((AdditionalFreeBytesNeeded + 1023) / 1024));
        InsufficientSpaceTextWithSize = GetTokenisedString(AutoSaveInsufficientSpaceTextPS3);
        ClearCustomTokens();
        GuiMan = GetScaleFormManager();
        if (GuiMan != None)
        {
            GuiMan.QueueNamedMessageBoxEx('AutoSaveFailed', 3, InsufficientSpaceTextWithSize, Params, HandleNoFreeSpacePS3Callback);
        }
        bPendingDisableAutoSave = TRUE;
        ProfileSettings = GetProfileSettings();
        if (ProfileSettings != None)
        {
            ProfileSettings.SetAutoSaveConfigOption(FALSE);
        }
    }
}
private final function SetCurrentSaveGame(SFXSaveDescriptor Descriptor)
{
    local SFXProfileSettings ProfileSettings;
    local int PreviousEncodedSaveDescriptor;
    local int EncodedSaveDescriptor;
    local int SafeIndex;
    
    ProfileSettings = GetProfileSettings();
    if (ProfileSettings != None)
    {
        SafeIndex = Descriptor.Index == -1 ? 0 : Descriptor.Index;
        EncodedSaveDescriptor = int(Descriptor.Type) * 1000000 + SafeIndex;
        ProfileSettings.SetCurrentCareerName(Descriptor.Career);
        ProfileSettings.GetProfileSettingValueInt(56, PreviousEncodedSaveDescriptor);
        if (PreviousEncodedSaveDescriptor != EncodedSaveDescriptor)
        {
            ProfileSettings.SetProfileSettingValueInt(56, EncodedSaveDescriptor);
        }
    }
}
private final function SaveGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess)
    {
        UpdateCurrentSaveGame(Args.Descriptor);
    }
    else if (Args.bNeedsFreeSpace && Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        HandleNoFreeSpacePS3(Args.Descriptor.Type, Args.AdditionalFreeBytesNeeded);
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        if (Abs(LastCantContinueTime - LastSaveTime) < 1.0)
        {
            Args.bRetry = TRUE;
            Args.bPause = srCantContinueErrorMessage != 0;
        }
    }
}
public final function UpdateCurrentSaveGame(SFXSaveDescriptor SaveDescriptor)
{
    SetCurrentSaveGame(SaveDescriptor);
    bPendingSaveProfile = TRUE;
    UpdateCareerCache(SaveDescriptor, CurrentSaveGame);
}
public final function SaveGameEx(SFXSaveDescriptor SaveDescriptor)
{
    local array<WeaponSaveRecord> W;
    local int I;
    local string HWWeaponClass;
    local int HWAmmoUsedCount;
    
    Class'ESM_LE2'.default.HWWeaponClass = "None";
    Class'ESM_LE2'.default.HWAmmoUsedCount = 0;
    if (SaveDescriptor.Type == ESFXSaveGameType.SaveGameType_Auto)
    {
        W = CurrentSaveGame.PlayerRecord.Weapons;
        for (I = W.Length - 1; I >= 0; I--)
        {
            HWWeaponClass = string(W[I].WeaponClassName);
            HWAmmoUsedCount = W[I].AmmoUsedCount;
            if (InStr(HWWeaponClass, "ESM_", , , ) == 0)
            {
                Class'ESM_LE2'.default.HWWeaponClass = Right(HWWeaponClass, Len(HWWeaponClass) - 4);
                Class'ESM_LE2'.default.HWAmmoUsedCount = HWAmmoUsedCount;
                break;
            }
            if (InStr(HWWeaponClass, "SFXHeavyWeapon_", , , ) == 0)
            {
                Class'ESM_LE2'.default.HWWeaponClass = HWWeaponClass;
                Class'ESM_LE2'.default.HWAmmoUsedCount = HWAmmoUsedCount;
                break;
            }
        }
    }
    QueueSaveGameCommand(2, SaveDescriptor, SaveGameCallback);
}
public final function CheckForCorruptCareers()
{
    local MassEffectGuiManager GuiMan;
    local BioSFHandler_MessageBox MessageBox;
    local BioMessageBoxOptionalParams Params;
    
    if (CorruptedCareers.Length > 0)
    {
        GuiMan = GetScaleFormManager();
        if (GuiMan == None)
        {
            return;
        }
        MessageBox = GuiMan.CreateMessageBox();
        MessageBox.SetInputDelegate(Callback_ConfirmDeleteCorruptCareers);
        Params.srAText = ConfirmDeleteCorruptText;
        Params.srBText = CancelDeleteCorruptText;
        Params.bNoFade = TRUE;
        MessageBox.DisplayMessageBox(CorruptCareerWarningText, Params);
    }
}
public final function bool RemoveCachedCareer(string Career)
{
    local int Index;
    
    for (Index = 0; Index < CareerCache.Length; ++Index)
    {
        if (CareerCache[Index].Career == Career)
        {
            CareerCache.Remove(Index, 1);
            return TRUE;
        }
    }
    return FALSE;
}
public final native function ResumeRendering();

public final native function SuspendRendering();

public final native function Callback_ConfirmDeleteCorruptCareers(bool bAPressed, int context);

public final native function ClearSaveCache();

public final native function string ValidCharsFilter(string Sin, bool bFilterAccentedChars);

public final native function CacheProfileData(SFXProfileSettings Profile);

public final native function LoadSaveGame(SFXSaveGame SaveGame);

public final native function bool IsPerformingSaveAction(ESFXSaveGameAction eAction);

public final native function bool IsSaving();

public final native function ScanSaveDataComplete(SFXSaveGameCommandEventArgs Args);

public final native function ScanSaveData();

public final native function bool TryGetCachedCareer(string Career, out SFXCareerCacheEntry OutEntry);

public final native function UpdateCareerCache(SFXSaveDescriptor SaveDescriptor, SFXSaveGame SaveGame);

public final native function ImportME2Character(SFXSaveGame SaveGame);

public final function ImportME1Character(SFXSaveGame SaveGame)
{
    if (SaveGame != None && SaveGame.bIsValid)
    {
        ME1ImportData = new Class'SFXLegacyData';
        ME1ImportData.ProcessME1SaveGame(SaveGame);
        CurrentSaveGame = new (Self) Class'SFXSaveGame';
        bNewPlayer = FALSE;
        BioWorldInfo(GetCurrentWorldInfo()).RequestStartNewGame(ME1ImportData.IsFemale());
    }
}
public final native function ResumeSaveGameCommandExecution();

public final native function QueueSaveGameCommand(ESFXSaveGameAction Action, optional const SFXSaveDescriptor SaveDescriptor, optional delegate<SFXSaveCommandCallback> Callback);

public final native function ClearCurrentSaveDescriptor();

public final native function SFXSaveDescriptor GetCurrentSaveDescriptor();

public final native function bool ParseCareer(string Career, out string FirstName, out string ClassName, out EOriginType Origin, out ENotorietyType Notoriety, out int Year, out int Month, out int Day, optional out int MSSinceMidnight);

public final native function GenerateCareer(string FirstName, string ClassName, EOriginType Origin, ENotorietyType Notoriety, int Year, int Month, int Day, int MSSinceMidnight, out string OutCareer, out string OutDisplayName);

public final native function CreateCareerInternal(string FirstName, string ClassName, EOriginType Origin, ENotorietyType Notoriety, int Year, int Month, int Day, int MSSinceMidnight);

public final native function CreateCareer(string FirstName, stringref srClass, EOriginType Origin, ENotorietyType Notoriety);

public delegate function OnResumeGameComplete(bool bWasSuccessful);

public delegate function SFXSaveCommandCallback(SFXSaveGameCommandEventArgs Args);

public static final native function float CurrentSystemTimeSeconds();

public static final native function ReleaseSeekFreeObject(string ObjectName);

public static final native function Object LoadSeekFreeObjectAsync(string Object, Class<Object> ObjectClass, out EAsyncLoadStatus Status);

public static final native function Object LoadSeekFreeObject(string ObjectName, Class<Object> ObjectClass);

public static final native function bool IsSeekFreeObjectSupported(string ObjectName);

public native function LaunchUnreaperWithDiscCheck();

public static final native function LaunchUnreaper();

public native function ReLaunchExecutable();

public static final native function SkipMovie();

public static final native function ResetForcedInactiveParticleSystems();

public static final native function SFXEngine GetEngine();

public static final native function PlayerInfoEx CurrentPlayerInfo();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXLoadMovieManager Name=oLoadMovieManager
    End Object
    DefaultPlayer = {
                     FirstName = "John", 
                     FaceCode = "", 
                     CharacterClass = Class'SFXPawn_PlayerSoldier', 
                     MorphHead = None, 
                     BonusTalentClass = 'None', 
                     bIsFemale = FALSE, 
                     Origin = EOriginType.OriginType_Earthborn, 
                     Notoriety = ENotorietyType.NotorietyType_Survivor
                    }
    DynamicLoadMapping = ({ObjectName = "SFXGamePawns.SFXCharacterClass_Adept", SeekFreePackageName = 'SFXCharacterClass_Adept', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGamePawns.SFXCharacterClass_Engineer", SeekFreePackageName = 'SFXCharacterClass_Engineer', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGamePawns.SFXCharacterClass_Infiltrator", SeekFreePackageName = 'SFXCharacterClass_Infiltrator', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGamePawns.SFXCharacterClass_Sentinel", SeekFreePackageName = 'SFXCharacterClass_Sentinel', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGamePawns.SFXCharacterClass_Soldier", SeekFreePackageName = 'SFXCharacterClass_Soldier', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGamePawns.SFXCharacterClass_Vanguard", SeekFreePackageName = 'SFXCharacterClass_Vanguard', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_RocketLauncher", SeekFreePackageName = 'SFXHeavyWeapon_RocketLauncher', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_GrenadeLauncher", SeekFreePackageName = 'SFXHeavyWeapon_GrenadeLauncher', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_NukeLauncher", SeekFreePackageName = 'SFXHeavyWeapon_NukeLauncher', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_ParticleBeam", SeekFreePackageName = 'SFXHeavyWeapon_ParticleBeam', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_FreezeGun", SeekFreePackageName = 'SFXHeavyWeapon_FreezeGun', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXHeavyWeapon_MissileLauncher", SeekFreePackageName = 'SFXHeavyWeapon_MissileLauncher', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_AssaultRifle", SeekFreePackageName = 'SFXWeapon_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_MachineGun", SeekFreePackageName = 'SFXWeapon_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_MiniGun", SeekFreePackageName = 'SFXWeapon_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_Needler", SeekFreePackageName = 'SFXWeapon_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_GethPulseRifle", SeekFreePackageName = 'SFXWeapon_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_AutoPistol", SeekFreePackageName = 'SFXWeapon_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_LightPistol", SeekFreePackageName = 'SFXWeapon_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_SMG", SeekFreePackageName = 'SFXWeapon_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_HeavyPistol", SeekFreePackageName = 'SFXWeapon_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_HandCannon", SeekFreePackageName = 'SFXWeapon_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_Shotgun", SeekFreePackageName = 'SFXWeapon_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_HeavyShotgun", SeekFreePackageName = 'SFXWeapon_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_FlakGun", SeekFreePackageName = 'SFXWeapon_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_SniperRifle", SeekFreePackageName = 'SFXWeapon_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_AntiMatRifle", SeekFreePackageName = 'SFXWeapon_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Inventory.SFXWeapon_MassCannon", SeekFreePackageName = 'SFXWeapon_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_ArmorPiercingAmmo_Player", SeekFreePackageName = 'SFXPower_ArmorPiercingAmmo_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_Barrier_Player", SeekFreePackageName = 'SFXPower_Barrier_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_Crush_Player", SeekFreePackageName = 'SFXPower_Crush_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_Fortification_Player", SeekFreePackageName = 'SFXPower_Fortification_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_GethShieldBoost_Player", SeekFreePackageName = 'SFXPower_GethShieldBoost_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_Reave_Player", SeekFreePackageName = 'SFXPower_Reave_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_ShieldJack_Player", SeekFreePackageName = 'SFXPower_ShieldJack_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_WarpAmmo_Player", SeekFreePackageName = 'SFXPower_WarpAmmo_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_NeuralShock_Player", SeekFreePackageName = 'SFXPower_NeuralShock_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_Dominate_Player", SeekFreePackageName = 'SFXPower_Dominate_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "SFXGameContent_Powers.SFXPower_AntiOrganicAmmo_Player", SeekFreePackageName = 'SFXPower_AntiOrganicAmmo_Player', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "BIOG_GesturesConfig.RuntimeData", SeekFreePackageName = 'GesturesConfig', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.AssaultRifle_512", SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Needler_512", SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.GethPulseRifle_512", SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Machinegun_512", SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Shotgun_512", SeekFreePackageName = 'SFXWeaponImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.FlakCannon_512", SeekFreePackageName = 'SFXWeaponImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.HeavyShotgun_512", SeekFreePackageName = 'SFXWeaponImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.MachinePistol_512", SeekFreePackageName = 'SFXWeaponImages_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Sub-MachineGun_512", SeekFreePackageName = 'SFXWeaponImages_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.HeavyPistol_512", SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.HandCannon_512", SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.SniperRifle_512", SeekFreePackageName = 'SFXWeaponImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Anti-MaterialRifle_512", SeekFreePackageName = 'SFXWeaponImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.MassCannon_512", SeekFreePackageName = 'SFXWeaponImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.GrenadeLauncher_512", SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.MissileLauncher_512", SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.CryoGun_512", SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.NukeLauncher_512", SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.ArmorPiercingAmmo_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Barrier_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Slam_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Fortification_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Reave_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.EnergyDrain_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.ShredderAmmo_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.WarpAmmo_512", SeekFreePackageName = 'SFXWeaponImages_PowerImages', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Garrus_512", SeekFreePackageName = 'SFXWeaponImages_GarrusImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Grunt_512", SeekFreePackageName = 'SFXWeaponImages_GruntImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Jack_512", SeekFreePackageName = 'SFXWeaponImages_JackImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Jacob_512", SeekFreePackageName = 'SFXWeaponImages_JacobImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Legion_512", SeekFreePackageName = 'SFXWeaponImages_LegionImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Miranda_512", SeekFreePackageName = 'SFXWeaponImages_MirandaImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Mordin_512", SeekFreePackageName = 'SFXWeaponImages_MordinImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Samara_512", SeekFreePackageName = 'SFXWeaponImages_SamaraImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Tali_512", SeekFreePackageName = 'SFXWeaponImages_TaliImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Codex_Images.Thane_512", SeekFreePackageName = 'SFXWeaponImages_ThaneImage', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.AutoPistol_256", SeekFreePackageName = 'SFXNotificationImages_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.SMG_256", SeekFreePackageName = 'SFXNotificationImages_AutoPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.HeavyPistol_256", SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.HandCannon_256", SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.SniperRifle_256", SeekFreePackageName = 'SFXNotificationImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MaterialRifle_256", SeekFreePackageName = 'SFXNotificationImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MassCannon_256", SeekFreePackageName = 'SFXNotificationImages_SniperRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.Shotgun_256", SeekFreePackageName = 'SFXNotificationImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.HeavyShotgun_256", SeekFreePackageName = 'SFXNotificationImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.FlakCannon_256", SeekFreePackageName = 'SFXNotificationImages_Shotguns', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.AssaultRifle_256", SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.Needler_256", SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.Machinegun_256", SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.GethPulseRifle_256", SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.GrenadeLauncher_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.CryoGun_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.GethPulseRifle_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.NukeLauncher_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.ParticleBeam_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MissileLauncher_256", SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.KroganUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.GethUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.JackUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MordinUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.ShieldUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_SquadUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.BioticUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_SquadUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.CyberneticUpgradeShepard_256", SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MediGelUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.HeavyWeaponUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.NormandyUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MiniGameDecryptUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Notifications.MiniGameHackUpgrade_256", SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.AssaultRifle_Kinetic", SeekFreePackageName = 'SFXNotification_ARUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.AssaultRifle_Tungsten", SeekFreePackageName = 'SFXNotification_ARUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.AssaultRifle_Targeting", SeekFreePackageName = 'SFXNotification_ARUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SMG_Microfield", SeekFreePackageName = 'SFXNotification_APistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SMG_Phasic", SeekFreePackageName = 'SFXNotification_APistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SMG_Heatsink", SeekFreePackageName = 'SFXNotification_APistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Biotics_NeuralMask", SeekFreePackageName = 'SFXNotification_BiotitcUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Biotics_NeuralMask02", SeekFreePackageName = 'SFXNotification_BiotitcUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Biotics_HyperAmp", SeekFreePackageName = 'SFXNotification_BiotitcUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Prototypes_Grunt", SeekFreePackageName = 'SFXNotification_HenchUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.PrototypesShep_Legion", SeekFreePackageName = 'SFXNotification_HenchUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.HeavyWeapons_MFA", SeekFreePackageName = 'SFXNotification_HvyWeaponUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.HeavyPistol_Pulsar", SeekFreePackageName = 'SFXNotification_HPistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.HeavyPistol_Sabot", SeekFreePackageName = 'SFXNotification_HPistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.HeavyPistol_Smartrounds", SeekFreePackageName = 'SFXNotification_HPistolUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Microscanner", SeekFreePackageName = 'SFXNotification_MediGelUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Trauma", SeekFreePackageName = 'SFXNotification_MediGelUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Harmonics", SeekFreePackageName = 'SFXNotification_MediGelUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.PrototypesShep_Lattice", SeekFreePackageName = 'SFXNotification_ShepardUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.PrototypesShep_Fiberweave", SeekFreePackageName = 'SFXNotification_ShepardUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.PrototypesShep_Skeletal", SeekFreePackageName = 'SFXNotification_ShepardUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Ablative", SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Burstshield", SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Armor_Nanocrystal", SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Shotgun_Pulsar", SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Shotgun_Micropulse", SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.Shotgun_Thermal", SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SniperRifle_Pulsar", SeekFreePackageName = 'SFXNotification_SniperUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SniperRifle_Tungsten", SeekFreePackageName = 'SFXNotification_SniperUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.SniperRifle_Scanner", SeekFreePackageName = 'SFXNotification_SniperUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.OmniTools_Heuristics", SeekFreePackageName = 'SFXNotification_TechUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.OmniTools_Hydra", SeekFreePackageName = 'SFXNotification_TechUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}, 
                          {ObjectName = "GUI_Icons.OmniTools_Multicore", SeekFreePackageName = 'SFXNotification_TechUpgrades', CachedObjectHandle = None, LoadedLinkerRoot = None}
                         )
    LoadMovieManager = oLoadMovieManager
    AutoSaveInsufficientSpaceTextPS3 = $386027
    InsufficentSpaceAcknowledgedText = $153007
    CorruptCareerWarningText = $349279
    ConfirmDeleteCorruptText = $147164
    CancelDeleteCorruptText = $147165
    bCanWriteSaveToStorage = TRUE
}