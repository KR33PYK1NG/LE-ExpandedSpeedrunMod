Class BioWorldInfo extends WorldInfo
    native
    config(Game);

// Types
struct native BoughtVFXListEnds 
{
    var int HeadIndex;
    var int TailIndex;
};
struct native VFXListNode 
{
    var BioVisualEffect Effect;
    var int NextNode;
    var int PrevNode;
    var bool ValidNode;
};
struct native VFXTemplatePoolSizeSpec 
{
    var(VFXTemplatePoolSizeSpec) BioVFXTemplate Template;
    var(VFXTemplatePoolSizeSpec) int MaxPoolSize;
    var(VFXTemplatePoolSizeSpec) int MinPoolSize;
};
struct native WorldEnvironmentEffect 
{
    var Vector m_vOffset;
    var transient BioVisualEffect m_Effect;
    var Controller m_TargetController;
    var float m_fBlendDuration;
    var float m_fBlendTime;
    var float m_fDesiredIntensity;
    var float m_fCurrentIntensity;
    var bool m_bAttachToCamera;
};
struct native WorldStreamingState 
{
    var(WorldStreamingState) Name Name;
    var(WorldStreamingState) bool Enabled;
};
struct native SlowMotionRequestType 
{
    var int nReqID;
    var float fSpeed;
    var float fLifeTime;
    var int nPriority;
    var bool bIndefinite;
};
enum BioBrowserStates
{
    BBS_NORMAL,
    BBS_ALERT,
    BBS_DISABLED,
};
enum MEBrowserWheelSubPages
{
    MBW_SP_Map,
    MBW_SP_Save,
    MBW_SP_CharacterRecord,
    MBW_SP_Load,
    MBW_SP_Journal,
    MBW_SP_DataPad,
    MBW_SP_Inventory,
    MBW_SP_Options,
};
enum JournalSortMethods
{
    JSM_Newest,
    JSM_Name,
    JSM_Oldest,
};
enum EPlayerRenderStateSetting
{
    PRSS_NEARCLIP,
};
enum BioLevelTypeObjectType
{
    BIO_LTYPE_HUB,
    BIO_LTYPE_COMBAT,
};
enum BioLocalVariableObjectType
{
    BIO_LVOT_PLAYER,
    BIO_LVOT_OWNER,
    BIO_LVOT_TARGET,
    BIO_LVOT_BYTAG,
    BIO_LVOT_SPEAKER,
};

// Variables
var transient array<stringref> lstNoSaveVolumeReasons;
var config array<string> GlobalTlkFiles;
var transient array<BioTlkFile> lstMaleTlkFiles;
var transient array<BioTlkFile> lstFemaleTlkFiles;
var array<Class<Actor>> lstOverlapToTouchClasses;
var export array<BioItem> m_buybackItemArray;
var config string m_lootBagActorType;
var(BioWorldInfo) string m_sFriendlyName;
var transient string m_sCinematicSkipEvent;
var config transient array<float> m_fLookAtDelays;
var array<SlowMotionRequestType> m_SlowMotionQ;
var(BioWorldInfo) array<WorldStreamingState> m_WorldStreamingStates;
var(VFXPool) array<VFXTemplatePoolSizeSpec> m_VFXTemplatePoolSizeOverride;
var transient array<VFXListNode> m_BoughtVFXList;
var config array<string> lstStateEventMapNames;
var config array<string> lstConsequenceMapNames;
var config array<string> lstOutcomeMapNames;
var config array<string> lstQuestMapNames;
var config array<string> lstCodexMapNames;
var config string InGameManualMapName;
var array<BioStateEventMap> lstStateEventMaps;
var array<BioStateEventMap> lstConsequenceMaps;
var array<BioOutcomeMap> lstOutcomeMaps;
var array<BioQuestMap> lstQuestMaps;
var array<BioCodexMap> lstCodexMaps;
var(BioWorldInfo) array<string> m_lstCinematicsSeen;
var(BioWorldInfo) string m_sDestinationAreaMap;
var(BioWorldInfo) array<int> m_pScannedClusters;
var(BioWorldInfo) array<int> m_pScannedSystems;
var(BioWorldInfo) array<int> m_pScannedPlanets;
var transient array<BioPawnBehavior> m_oResetBehaviors;
var transient array<BioActorBehavior> m_aOrphanedBehaviors;
var transient array<BioMusicVolume> BioRegisteredMusic;
var delegate<TutorialCompletionCallback> __TutorialCompletionCallback__Delegate;
var const transient native Object m_mVFXPool;
var const transient native Object m_BoughtVFXMap;
var WorldEnvironmentEffect m_ActiveEnvironmentEffect;
var WorldEnvironmentEffect m_PendingEnvironmentEffect;
var const transient native BoughtVFXListEnds m_aBoughtEffects[5];
var(BioWorldInfo) Vector m_vDestination;
var transient BioPlayerSquad m_playerSquad;
var transient BioSaveGame CurrentGame;
var transient Actor oPlayerSavePosOverride;
var BioTimerList TimerList;
var transient BioGlobalVariableTable m_oGlobalVariables;
var transient BioQuestProgressionMap m_oQuestProgress;
var transient BioDiscoveredCodexMap m_oDiscoveredCodex;
var transient BioCodexMap m_oInGameManual;
var transient BioConversation m_oCurrentConversation;
var transient BioSeqAct_FaceOnlyVO m_pCurrentFaceOnlyVO;
var BioPlayerController LocalPlayerController;
var Name m_lootBagTag;
var BioSubtitles m_Subtitles;
var(BioWorldInfo) GFxMovieInfo m_oAreaMap;
var(BioWorldInfo) GFxMovieInfo m_oParentAreaMap;
var BioBaseSquad m_oDefaultSquad;
var BioBaseSquad m_oPlayerSquad;
var const BioArtPlaceable ArtPlaceableList;
var BioInGamePropertyEditor m_oPropertyEditor;
var Bio2DA oTutorials2DA;
var editinline export AudioComponent m_pEndGameMusic;
var const SoundCue m_pEndGameMusicSoundCue;
var transient export BioEventNotifier EventNotifier;
var export BioInventory m_oPendingLoot;
var transient export BioInventory m_oMomentaryLoot;
var transient export BioPhysicsSounds m_PhysicsSound;
var(BioWorldInfo) const export BioUIWorld m_UIWorld;
var export BioSkillGame m_SkillGame;
var export BioPowerManager m_oPowerManager;
var config int WindEnableFake;
var config float WindGustChance;
var config int WindBase;
var config int WindMax;
var config float WindShortestGustTime;
var config float WindLongestGustTime;
var config int WindBaseYaw;
var float m_fFakeWindGustTime;
var float m_fFakeWindGustCalcTime;
var float m_fFakeWindCurGustLength;
var float m_fFakeWindMag;
var int m_nWindYaw;
var float m_nWindGrowthA;
var float m_nWindGrowthB;
var transient int nNoSaveVolumeCount;
var transient stringref srNoSaveReason;
var config stringref srDefaultNoSaveReason;
var config stringref srNoSaveInCombat;
var config stringref srNoSaveWhenVehicleBadPlace;
var transient int m_nJournalLastSelectedMission;
var transient int m_nJournalLastSelectedAssignment;
var transient int m_nCodexLastSelectedPrimary;
var transient int m_nCodexLastSelectedSecondary;
var transient float m_fNoBrowserWheelTimer;
var config int m_buybackArrayMaxSize;
var transient float m_fCinematicStartTime;
var transient int m_nMiniGameID;
var config int m_nScalePawnsToCharacterLevel;
var config float m_fConversationInterruptDistance;
var config float m_fIdleCameraSpeed;
var config transient float m_fNoSkipBuffer;
var config transient float m_fLookAtNoticeMaxRange;
var config transient float m_fLookAtNoticeInitialDelay;
var config transient float m_fLookAtNoticeDuration;
var config transient float m_fLookAtNoticeSpeed;
var int m_nCurrentTipID;
var stringref m_OverrideTip;
var config stringref m_srProfileNotSignedInWarningMsg;
var int m_nSlowMotionState;
var float m_fCurrentSlomo;
var float m_fInterpStepSize;
var int m_nNextAssignableID;
var config float m_fMaxVFXBudget;
var float m_fUsedVFXBudget;
var config stringref srTutorialOK;
var const config float m_fGameOverPauseTime;
var transient int bForceFullGarbageCollection;
var config transient int m_nDesignerEnableTutorialPlotFlag;
var config transient int m_nDesignerEnableDifficultyChecksPlotFlag;
var transient bool bStreamingLevelsResorted;
var const config bool m_bAllowTreasureLogging;
var transient bool bDesignerSaysNoSave;
var transient bool bSystemNoSave;
var transient bool m_bJournalShowingMissions;
var transient bool m_bCodexShowingPrimary;
var(BioWorldInfo) bool m_bBuildLongPathsForMap;
var transient bool m_bCinematicSkip;
var transient bool m_bDisableCinematicSkip;
var transient bool m_bForceCinematicDamage;
var bool m_bFlushSFHud;
var transient bool m_bCauseUnscaledDamage;
var config bool m_bDebugCameras;
var transient bool m_bShowAlignmentGains;
var config bool m_bPartyMembersImmuneToExternalForce;
var bool m_bSetGameSpeed;
var config bool m_bForceDisableTutorials;
var transient bool m_bPausedByFocusLoss;
var transient bool m_bWaitingForStreamingLoadIdle;
var transient bool m_bWaitingForStreamingLoadVisibleComplete;
var transient bool m_bHasPlayerTeleported;
var config bool m_bShowVinceSurveys;
var transient bool m_bMessageBoxTutorialVisible;
var transient bool m_bLastSaveCreatorInvalid;
var transient bool m_bLastProfileCreatorInvalid;
var transient bool m_bGameWasPaused;
var transient bool bTriggeredGameOver;
var transient BioBrowserStates m_lstBrowserAlerts[8];
var transient JournalSortMethods m_nJournalSortMethod;
var(BioWorldInfo) BioLevelTypeObjectType m_LevelType;

// Functions
public event function SetPlayersControllerId(LocalPlayer Player, int ControllerId)
{
    Player.SetControllerId(ControllerId);
}
public event function StartNoBrowserWheelTimer()
{
    m_fNoBrowserWheelTimer = 1.0;
}
public native function bool SaveGamesExist();

public event function UpdateLowestCombatDifficulty()
{
    local int nCombatDifficulty;
    local BioGamerProfile oGP;
    
    nCombatDifficulty = 0;
    oGP = GetBioGamerProfile();
    if (oGP != None && CurrentGame != None)
    {
        oGP.GetOption(0, nCombatDifficulty);
        if (CheckState(m_nDesignerEnableDifficultyChecksPlotFlag) == FALSE)
        {
            CurrentGame.m_nLowestCombatDifficultyUsed = nCombatDifficulty;
            if (((m_playerSquad != None && m_playerSquad.m_playerPawn != None) && m_playerSquad.m_playerPawn.m_oBehavior != None) && int(m_playerSquad.m_playerPawn.m_oBehavior.GetMarshalRank()) > 0)
            {
                CurrentGame.m_bSecondPlaythrough = TRUE;
            }
        }
        else if (CurrentGame.m_nLowestCombatDifficultyUsed > nCombatDifficulty)
        {
            CurrentGame.m_nLowestCombatDifficultyUsed = nCombatDifficulty;
        }
    }
}
public event function BioStartMatch()
{
    local BioPawn oPlayer;
    local BioWorldInfo oBWorldInfo;
    local BioGamerProfile oGP;
    local int nSecondsPlayed;
    local int nHrPlayed;
    local int nMinPlayed;
    local string sStartMapName;
    local string sMapName;
    local int nTemp;
    
    oBWorldInfo = BioWorldInfo(WorldInfo);
    if (oBWorldInfo != None)
    {
        oGP = oBWorldInfo.GetBioGamerProfile();
        if (oBWorldInfo.m_playerSquad != None)
        {
            oPlayer = oBWorldInfo.m_playerSquad.m_playerPawn;
            if (oPlayer != None)
            {
                sStartMapName = "EntryMenu";
                sMapName = oBWorldInfo.GetURLMap();
                nTemp = Len(sStartMapName);
                sMapName = Mid(sMapName, 0, nTemp);
                if (sMapName != sStartMapName)
                {
                    oPlayer.SetRichPresence();
                    if (oGP != None)
                    {
                        oBWorldInfo.CurrentGame.GetTimePlayed(nSecondsPlayed, nMinPlayed, nHrPlayed);
                        oGP.UpdateCharacterProfilePawnData(oBWorldInfo.CurrentGame.m_sCharacterID, oPlayer, nHrPlayed, nMinPlayed, nSecondsPlayed, TRUE);
                    }
                    oBWorldInfo.UpdateLowestCombatDifficulty();
                }
            }
        }
        bSystemNoSave = FALSE;
    }
    OnBioMatchStart();
}
public static function Class<BioBaseSaveObject> GetSaveObjectClass()
{
    return Class'BioWorldInfoSaveObject';
}
public function OnPlayerSquadDeath()
{
    EndGame();
}
public function EndGame(optional stringref srGameOverString)
{
    local BioPlayerController PC;
    
    if (!bTriggeredGameOver)
    {
        bTriggeredGameOver = TRUE;
        BioVINCE_MapName_PlayerDeath();
        if (LocalPlayerController != None)
        {
            if (LocalPlayerController.GetScaleFormManager() != None)
            {
                MassEffectGuiManager(LocalPlayerController.GetScaleFormManager()).OnPlayerDeath();
            }
        }
        foreach WorldInfo.AllControllers(Class'BioPlayerController', PC)
        {
            PC.GameModeManager.EnableMode(7);
        }
        bPlayersOnly = FALSE;
        BioSPGame(Game).srGameOverString = srGameOverString;
        Game.SetTimer(m_fGameOverPauseTime, FALSE, 'SpawnGameOverGUI', );
        PlayEndGameMusic();
    }
}
public native function OnSaveGameNotFound(optional Object oDelegateObject, optional Name nmDelegateFunctionName);

public native function GetGlobalEvents(Class<Object> EventClass, out array<SequenceEvent> aEvents);

public native function SetSoundGroupPitch(Name SoundGroupName, float fPitch);

public native function float GetSoundGroupPitch(Name SoundGroupName);

public native function SetSoundGroupPriority(Name SoundGroupName, float fPriority);

public native function float GetSoundGroupPriority(Name SoundGroupName);

public native function SetSoundGroupVolume(Name SoundGroupName, float fVolume, optional float fFadeDuration = 0.0);

public native function float GetSoundGroupVolume(Name SoundGroupName);

public native function bool GetIsOriginalFileCreator();

public native function SetInvalidSaveFileCreator(byte nSaveFileType, bool bInvalid);

public native function SetDisplayRealSaveGameNames(bool i_bValue);

public native function bool GetDisplayRealSaveGameNames();

public native function SetGuiStartupSystemsInitialized(bool i_bValue);

public native function bool GetGuiStartupSystemsInitialized();

public native function SetRenderStateOfPlayerToDefault(EPlayerRenderStateSetting RenderState);

public native function SetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState, float fValue);

public native function float GetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState);

public native function UpdateEnvironmentEffects(float fDeltaT);

public function UpdateSubtitles(float fDeltaT)
{
    if (m_Subtitles != None)
    {
        m_Subtitles.UpdateSubtitles(fDeltaT);
    }
}
public native function BioSubtitles GetSubtitles();

public function ApplyWind(float fDeltaT)
{
    local KAsset TempActor;
    local Rotator rImp;
    local Vector vImpulse;
    local Name bn;
    local int I;
    
    foreach AllActors(Class'KAsset', TempActor, )
    {
        if (TempActor != None)
        {
            rImp.Yaw = int(float(m_nWindYaw) * 182.044449);
            rImp.Pitch = 0;
            rImp.Roll = 0;
            vImpulse = vect(1.0, 0.0, 0.0) >> rImp;
            vImpulse *= m_fFakeWindMag;
            I = 0;
            bn = TempActor.SkeletalMeshComponent.FindConstraintBoneName(I);
            while (bn != 'None')
            {
                TempActor.SkeletalMeshComponent.AddImpulse(vImpulse, , bn);
                I++;
                bn = TempActor.SkeletalMeshComponent.FindConstraintBoneName(I);
            }
        }
    }
}
public function AdjustWind(float fDeltaT)
{
    if (m_fFakeWindGustTime > 0.0)
    {
        m_fFakeWindMag = float(Max(Min(int(m_nWindGrowthA * Exp(m_nWindGrowthB * m_fFakeWindGustCalcTime)), WindMax), WindBase));
        if (m_fFakeWindGustTime <= m_fFakeWindCurGustLength * 0.5)
        {
            m_fFakeWindGustCalcTime += fDeltaT;
        }
        else
        {
            m_fFakeWindGustCalcTime -= fDeltaT;
        }
        m_fFakeWindGustTime += fDeltaT;
        if (m_fFakeWindGustTime > m_fFakeWindCurGustLength)
        {
            m_fFakeWindGustTime = -1.0;
            m_fFakeWindGustCalcTime = 0.0;
            m_fFakeWindMag = float(WindBase);
        }
    }
    else
    {
        if (RandRange(0.0, 100.0) < float(100) * WindGustChance)
        {
            m_nWindGrowthA = float(WindBase) + 1.0;
            m_nWindGrowthB = (2.0 * Loge(float(WindMax) / m_nWindGrowthA)) / WindLongestGustTime;
            m_fFakeWindGustTime = 0.00999999978;
            m_fFakeWindGustCalcTime = 0.0;
            m_fFakeWindCurGustLength = RandRange(WindShortestGustTime, WindLongestGustTime);
            AdjustWind(fDeltaT);
        }
        m_nWindYaw = WindBaseYaw;
    }
}
public function DoFakeWind(float fDeltaT)
{
    AdjustWind(fDeltaT);
    ApplyWind(fDeltaT);
}
public native function PrintSlowMotionQ();

public native function ClearAllSlowMotion();

public native function bool EndSlowMoRequest(int nReqID, float fExpireTime);

public native function int RequestSlowMotion(float fSpeed, float fLifeTime, int nPriority);

public native function UpdateSlowMotionQ(float fDeltaTime);

public native function SetGlobalTlk(bool bMale, optional bool bPurge = TRUE);

public native function LoadDLCTlkFiles(bool bMale, bool bFemale, bool bAddMale, bool bAddFemale);

public native function LoadTlkFiles(bool bMale, bool bFemale, bool bAddMale, bool bAddFemale);

public event simulated function BioBeginPlay()
{
    Super(Actor).BioBeginPlay();
    InitializeForPlay();
    TimerList = new (Outer) Class'BioTimerList';
    LoadTlkFiles(TRUE, TRUE, TRUE, FALSE);
    if (m_oPropertyEditor != None)
    {
        m_oPropertyEditor.Initialize();
    }
}
public native function bool IsAbleToSave(optional out string sReason);

public event function bool CheckState(int nState)
{
    local BioGlobalVariableTable gv;
    
    gv = GetGlobalVariables();
    return gv.GetBool(nState);
}
public native function InterruptConversation(optional BioConversation oConv);

public function UpdateConversation(float fDeltaT)
{
    if (m_oCurrentConversation == None)
    {
        return;
    }
    if (m_oCurrentConversation.UpdateConversation(fDeltaT) == FALSE)
    {
        EndCurrentConversation();
    }
}
public native function EndCurrentFaceOnlyVO(BioSeqAct_FaceOnlyVO pFOVO);

public native function EndCurrentConversation();

public native function bool StartConversation(BioConversation oConv, Actor Owner_, Actor Target);

public event function BioConversation GetConversation()
{
    return m_oCurrentConversation;
}
public event function ClearCurrentGame(optional bool bRestorGamerProfilePlotManagerVariables = TRUE)
{
    local BioGamerProfile oProfile;
    
    oProfile = GetBioGamerProfile();
    if (oProfile != None)
    {
        oProfile.SetGamerProfilePlotManagerVariables();
    }
    CurrentGame.ResetToDefaults();
    GetGlobalVariables().ClearAllVariables();
    m_oQuestProgress.Clear();
    m_oDiscoveredCodex.Clear();
    if (oProfile != None && bRestorGamerProfilePlotManagerVariables == TRUE)
    {
        oProfile.RestoreGamerProfilePlotManagerVariables();
    }
}
public native function BioGlobalVariableTable GetGlobalVariables();

public native function BioGamerProfile GetBioGamerProfile();

public final native function InitDownloadableContent();

public final native function InitGUIDependentStartupSystems(BioSFPanel i_oPanel);

public function Tick(float fDeltaT)
{
    local BioPlayerController PC;
    
    if (m_fNoBrowserWheelTimer > 0.0)
    {
        m_fNoBrowserWheelTimer -= fDeltaT;
    }
    PC = GetLocalPlayerController();
    if ((((!bPlayersOnly && !HasFocus()) && PC != None) && PC.GameModeManager != None) && PC.GameModeManager.CanPause())
    {
        PC.GameModeManager.TurnOffStormForPause();
        m_bPausedByFocusLoss = TRUE;
        bPlayersOnly = TRUE;
    }
    else if (HasFocus() && m_bPausedByFocusLoss)
    {
        m_bPausedByFocusLoss = FALSE;
        bPlayersOnly = FALSE;
    }
    TimerList.Tick(fDeltaT);
    UpdateSubtitles(fDeltaT);
    UpdateConversation(fDeltaT);
    UpdateSlowMotionQ(fDeltaT);
    if (m_bSetGameSpeed)
    {
        Game.SetGameSpeed(m_fCurrentSlomo);
        m_bSetGameSpeed = FALSE;
    }
    if (WindEnableFake == 1)
    {
        DoFakeWind(fDeltaT);
    }
    if (m_oPropertyEditor != None)
    {
        m_oPropertyEditor.UpdateSystem(fDeltaT);
    }
    UpdateVFXStats(fDeltaT);
    UpdateVFXPools(fDeltaT);
    CurrentGame.TryAutoSaving();
}
public native function bool HasFocus();

public native function bool LootBagActivated();

public native function bool CreateLootBag(const out Vector SpawnLocation, Level spawnLevel, string actorTypeString);

public native function BioPlayerController GetLocalPlayerController();

public delegate function TutorialCompletionCallback();

public native function BioVINCE_MapName_PlayerDeath();

public final native function PlayEndGameMusic();

public native function OnBioMatchStart();

public static native function BioCharacterImporter GetCharacterImporter();

public native function UpdateVFXPools(float fDeltaT);

public native function UpdateVFXStats(float fDeltaT);

public native function bool CheckResetBehavior(BioPawnBehavior pBehavior);

public native function ClearResetBehaviors();

public native function OverrideVFXPoolSize(BioVFXTemplate a_pEffect, int a_nMaxPoolSize, int a_nMinPoolSize);

public native function GetDefaultVFXPoolSize(BioVFXTemplate a_pEffect, out int a_rnMaxPoolSize, out int a_rnMinPoolSize);

public native function BioVisualEffectPool GetVFXPool(BioVFXTemplate pEffect);

private final native function OnGameLoaded();

private final native function InitializeForPlay();

public native function string GetDetailedVersionString();

public native function string GetEpicVersionString();

public native function string GetVersionString();

public final native function MoveToArea(Name sAreaName, Name sNextAreaStartPoint);

public final iterator native function AllBioActors(out Actor Actor, optional Name MatchTag);

public native function bool GetLocalBoolVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag);

public native function float GetLocalFloatVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag);

public native function int GetLocalIntegerVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag);

public native function ExecuteConsequence(int nConsequence, optional int nParam = 0);

public native function ExecuteStateTransition(int nTransition, optional int nParam = 0);

public native function bool CheckConditional(int nConditional, optional int nParam = 0);

public event function CauseEvent(Name EventName)
{
    if (GetLocalPlayerController() != None)
    {
        GetLocalPlayerController().CauseEvent(EventName);
    }
}
public final function TutorialDismissed(bool bAButtonPressed, int nContext)
{
    bPlayersOnly = m_bGameWasPaused;
    m_bMessageBoxTutorialVisible = FALSE;
    __TutorialCompletionCallback__Delegate();
}
public final native function bool GetGuiInputPermission(byte nEvent);

public final native function CancelTutorial(optional bool bFadeOut = TRUE, optional Name nmTutorial);

public final native function ClearTutorialsViewed();

public final native function bool IsTutorialRunning(optional Name nmTutorial);

public final native function bool GetTutorialViewed(Name nmTutorial);

public final native function SetTutorialViewed(Name nmTutorial);

public final native function ShowTutorialMessageBox(Object pCallbackObject, Name nmCallbackFunction, stringref srTutorial);

public final native function bool ShowTutorial(Name nmTutorial, optional bool bSetViewed = FALSE, optional Object oCallbackObject, optional Name oCallbackFunction, optional bool i_bIgnoreDesignerSuppression = FALSE);

public final native function ShowTutorialOverride(int srTutorialId);

public native function SetHasShownPRCMessage(bool i_bValue);

public native function bool GetHasShownPRCMessage();

public native function bool GetChallengeLevel(out int challengeLevel);

public native function float GetBuybackItemPriceAtIndex(int Index);

public native function BioItem RemoveBuybackItem(int Index);

public native function AppendBuybackItemsToInventory(out BioInventory Inventory);

public native function AddBuybackItem(BioItem Item);

public native function SetDebugSave(int nSet);

public native function BioDeleteGame(int nSaveGameSlot);

public native function BioLoadGame(int nSaveGameSlot);

public native function BioSaveGame(int nSaveGameSlot, Name sArea, bool bStartFromCurrentPosition, Name sNextAreaStartPoint);

public native function OnNewGameStartRequest();

public native function bool TriggerCinematicSkippedEvent();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDiscoveredCodexMap Name=BioDiscoveredCodex0
    End Object
    Begin Object Class=BioEventNotifier Name=BEN
    End Object
    Begin Object Class=BioGlobalVariableTable Name=BioGlobalVars0
    End Object
    Begin Object Class=BioInventory Name=oMomentaryLoot
    End Object
    Begin Object Class=BioInventory Name=oPendingLoot
    End Object
    Begin Object Class=BioPhysicsSounds Name=oPhysicsSound01
    End Object
    Begin Object Class=BioPowerManager Name=PowerManager
    End Object
    Begin Object Class=BioQuestProgressionMap Name=BioQuestProgress0
    End Object
    Begin Object Class=BioSkillGame Name=BioSkillGame01
    End Object
    Begin Object Class=BioUIWorld Name=oUIWorld
    End Object
    Begin Template Class=PhysicsLODVerticalDestructible Name=PhysicsLODVerticalDestructible0
    End Template
    Begin Template Class=PhysicsLODVerticalEmitter Name=PhysicsLODVerticalEmitter0
    End Template
    GlobalTlkFiles = ("GlobalTlk.GlobalTlk_tlk")
    lstOverlapToTouchClasses = (Class'BioTriggerVolume', Class'BioTrigger', Class'BioAreaTransition', Class'BioMountFallVolume', Class'BioAudioVolume')
    m_fLookAtDelays = (0.5, 
                       0.600000024, 
                       0.699999988, 
                       0.75, 
                       0.800000012, 
                       0.899999976, 
                       1.0, 
                       1.04999995, 
                       1.10000002, 
                       1.14999998
                      )
    lstStateEventMapNames = ("PlotManagerAuto.StateTransitionMap")
    lstConsequenceMapNames = ("PlotManagerAuto.ConsequenceMap")
    lstOutcomeMapNames = ("PlotManagerAuto.OutcomeMap")
    lstQuestMapNames = ("PlotManagerAuto.QuestMap")
    lstCodexMapNames = ("PlotManagerAuto.DataCodexMap")
    InGameManualMapName = "InGameManual.DataManualMap"
    m_oGlobalVariables = BioGlobalVars0
    m_oQuestProgress = BioQuestProgress0
    m_oDiscoveredCodex = BioDiscoveredCodex0
    m_lootBagTag = 'LootSystemLootBag'
    oTutorials2DA = Bio2DA'BIOG_2DA_UI_X.Tutorials_Tutorials'
    m_pEndGameMusicSoundCue = SoundCue'Music.mus_stingshort_gameover'
    EventNotifier = BEN
    m_oPendingLoot = oPendingLoot
    m_oMomentaryLoot = oMomentaryLoot
    m_PhysicsSound = oPhysicsSound01
    m_UIWorld = oUIWorld
    m_SkillGame = BioSkillGame01
    m_oPowerManager = PowerManager
    srDefaultNoSaveReason = $168056
    srNoSaveInCombat = $168057
    srNoSaveWhenVehicleBadPlace = $174024
    m_nJournalLastSelectedMission = -1
    m_nJournalLastSelectedAssignment = -1
    m_nCodexLastSelectedPrimary = -1
    m_nCodexLastSelectedSecondary = -1
    m_buybackArrayMaxSize = 20
    m_fConversationInterruptDistance = 2500.0
    m_fIdleCameraSpeed = 1.0
    m_fNoSkipBuffer = 0.699999988
    m_fLookAtNoticeMaxRange = 500.0
    m_fLookAtNoticeInitialDelay = 1.5
    m_fLookAtNoticeDuration = 6.0
    m_fLookAtNoticeSpeed = 0.200000003
    m_srProfileNotSignedInWarningMsg = $174310
    m_fCurrentSlomo = 1.0
    m_fInterpStepSize = 0.100000001
    m_fMaxVFXBudget = 1000.0
    srTutorialOK = $170655
    m_fGameOverPauseTime = 3.0
    m_nDesignerEnableTutorialPlotFlag = 7147
    m_nDesignerEnableDifficultyChecksPlotFlag = 2505
    bSystemNoSave = TRUE
    m_bJournalShowingMissions = TRUE
    m_bCodexShowingPrimary = TRUE
    m_bFlushSFHud = TRUE
    m_bPartyMembersImmuneToExternalForce = TRUE
    m_bWaitingForStreamingLoadIdle = TRUE
    m_bWaitingForStreamingLoadVisibleComplete = TRUE
    EmitterVertical = PhysicsLODVerticalEmitter0
    DestructibleVertical = PhysicsLODVerticalDestructible0
}