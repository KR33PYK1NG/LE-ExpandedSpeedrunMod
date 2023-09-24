Class BioWorldInfo extends WorldInfo
    native
    config(Game);

// Types
struct native EffectsMaterialPriority 
{
    var(EffectsMaterialPriority) Name EffectsMaterial;
    var(EffectsMaterialPriority) int Priority;
};
struct native SubPageState 
{
    var int nPadding;
    var(SubPageState) MEBrowserWheelSubPages Page;
    var(SubPageState) BioBrowserStates State;
};
struct native BoughtVFXListEnds 
{
    var int HeadIndex;
    var int TailIndex;
    
    structdefaultproperties
    {
        HeadIndex = -1
        TailIndex = -1
    }
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
struct native PlotStreamingSet 
{
    var(PlotStreamingSet) array<PlotStreamingElement> Elements;
    var(PlotStreamingSet) Name VirtualChunkName;
};
struct native PlotStreamingElement 
{
    var(PlotStreamingElement) Name ChunkName;
    var(PlotStreamingElement) int Conditional;
    var(PlotStreamingElement) bool bFallback;
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
    MBW_SP_Options,
    MBW_SP_ReturnToMainMenu,
    MBW_SP_ExitGame,
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
enum BioLocalVariableObjectType
{
    BIO_LVOT_PLAYER,
    BIO_LVOT_OWNER,
    BIO_LVOT_TARGET,
    BIO_LVOT_BYTAG,
    BIO_LVOT_SPEAKER,
};

// Variables
var(BioWorldInfo) string m_sFriendlyName;
var transient string m_sCinematicSkipEvent;
var config transient array<float> m_fLookAtDelays;
var array<Actor> SelectableActors;
var array<Actor> RadarActors;
var(BioWorldInfo) array<PlotStreamingSet> PlotStreaming;
var(BioWorldInfo) array<WorldStreamingState> m_WorldStreamingStates;
var(VFXPool) array<VFXTemplatePoolSizeSpec> m_VFXTemplatePoolSizeOverride;
var transient array<VFXListNode> m_BoughtVFXList;
var config array<string> ConditionalClasses;
var(BioWorldInfo) array<string> m_lstCinematicsSeen;
var(BioWorldInfo) string m_sDestinationAreaMap;
var(BioWorldInfo) array<int> m_pScannedClusters;
var(BioWorldInfo) array<int> m_pScannedSystems;
var(BioWorldInfo) array<int> m_pScannedPlanets;
var transient array<SubPageState> SubPageStateOverrides;
var(BioWorldInfo) config array<EffectsMaterialPriority> EffectsMaterialPriorities;
var(BioWorldInfo) array<Object> m_AutoPersistentObjects;
var const transient native Object m_mVFXPool;
var const transient native Object m_BoughtVFXMap;
var WorldEnvironmentEffect m_ActiveEnvironmentEffect;
var WorldEnvironmentEffect m_PendingEnvironmentEffect;
var const transient native BoughtVFXListEnds m_aBoughtEffects[5];
var(BioWorldInfo) Vector m_vDestination;
var transient BioPlayerSquad m_playerSquad;
var BioTimerList TimerList;
var transient BioGlobalVariableTable m_oGlobalVariables;
var transient BioQuestProgressionMap m_oQuestProgress;
var transient BioDiscoveredCodexMap m_oDiscoveredCodex;
var transient BioConversation m_oCurrentConversation;
var transient BioSeqAct_FaceOnlyVO m_pCurrentFaceOnlyVO;
var transient BioConversation m_pConvCondCheckOverride;
var BioPlayerController LocalPlayerController;
var BioSubtitles m_Subtitles;
var(BioWorldInfo) GFxMovieInfo m_oAreaMap;
var(BioWorldInfo) GFxMovieInfo m_oParentAreaMap;
var BioInGamePropertyEditor m_oPropertyEditor;
var WwiseEventPairObject m_pEndGameMusicEvent;
var const transient noimport WwiseEnvironmentVolume HighestPriorityAudioEnvVolume;
var transient export BioEventNotifier EventNotifier;
var transient export SFXPlotTreasure m_oTreasure;
var transient export BioPhysicsSounds m_PhysicsSound;
var(BioWorldInfo) const export BioUIWorld m_UIWorld;
var export BioPowerManager m_oPowerManager;
var config int nMemoryBudgetDLC;
var transient int m_nJournalLastSelectedMission;
var transient int m_nJournalLastSelectedAssignment;
var transient int m_nCodexLastSelectedPrimary;
var transient int m_nCodexLastSelectedSecondary;
var config float m_fConversationInterruptDistance;
var config float m_fIdleCameraSpeed;
var config transient float m_fNoSkipBuffer;
var config transient float m_fLookAtNoticeMaxRange;
var config transient float m_fLookAtNoticeInitialDelay;
var config transient float m_fLookAtNoticeDuration;
var config transient float m_fLookAtNoticeSpeed;
var config stringref m_srProfileNotSignedInWarningMsg;
var config float m_fMaxVFXBudget;
var float m_fUsedVFXBudget;
var const config float m_fGameOverPauseTime;
var transient int bForceFullGarbageCollection;
var config transient int m_nDesignerEnableDifficultyChecksPlotFlag;
var transient bool bStreamingLevelsResorted;
var transient bool m_bJournalShowingMissions;
var transient bool m_bCodexShowingPrimary;
var(BioWorldInfo) bool m_bInvokesHintMessages;
var transient bool m_bCinematicSkip;
var transient bool m_bDisableCinematicSkip;
var transient bool m_bForceCinematicDamage;
var bool m_bFlushSFHud;
var config bool m_bDebugCameras;
var config bool m_bPartyMembersImmuneToExternalForce;
var transient bool m_bPausedByFocusLoss;
var transient bool m_bWaitingForStreamingLoadIdle;
var transient bool m_bWaitingForStreamingLoadVisibleComplete;
var transient bool m_bGameWasPaused;
var transient bool bKismetShowHUD;
var(BioWorldInfo) bool m_bAllowBrowserWheel;
var transient BioBrowserStates m_lstBrowserAlerts[9];
var transient JournalSortMethods m_nJournalSortMethod;

// Functions
public event function SetPlayersControllerId(LocalPlayer Player, int ControllerId)
{
    Player.SetControllerId(ControllerId);
}
public function ClearBrowserWheelStateOverride()
{
    SubPageStateOverrides.Remove(0, SubPageStateOverrides.Length);
}
public function AddBrowserWheelStateOverride(SubPageState i_SubStateOverride)
{
    SubPageStateOverrides.AddItem(i_SubStateOverride);
}
public function StartMatch()
{
    local BioPawn oPlayer;
    local BioWorldInfo oBWorldInfo;
    local string sStartMapName;
    local string sMapName;
    local int nTemp;
    
    oBWorldInfo = BioWorldInfo(WorldInfo);
    if (oBWorldInfo != None)
    {
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
                }
            }
        }
    }
}
public native function GetGlobalEvents(Class<Object> EventClass, out array<SequenceEvent> aEvents);

public final native function SetRenderStateOfPlayerToDefault(EPlayerRenderStateSetting RenderState);

public final native function SetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState, float fValue);

public final native function float GetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState);

public final native function UpdateEnvironmentEffects(float fDeltaT);

public final native function BioSubtitles GetSubtitles();

public native function SetGlobalTlk(bool bMale, optional bool bPurge = TRUE);

public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    TimerList = new (Outer) Class'BioTimerList';
    if (m_oPropertyEditor != None)
    {
        m_oPropertyEditor.Initialize();
    }
    GetSubtitles();
}
public event function bool CheckState(int nState)
{
    local BioGlobalVariableTable gv;
    
    gv = GetGlobalVariables();
    return gv.GetBool(nState);
}
public native function InterruptConversation(optional BioConversation oConv);

public native function EndCurrentFaceOnlyVO(BioSeqAct_FaceOnlyVO pFOVO);

public native function EndCurrentConversation();

public native function bool StartConversation(BioConversation oConv, Actor Owner_, Actor Target);

public event function BioConversation GetConversation()
{
    return m_oCurrentConversation;
}
public event function ClearCurrentGame()
{
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetEngine();
    Engine.bStartedGame = FALSE;
    Engine.bNewPlayer = FALSE;
    Engine.m_DesiredStartPoint = 'None';
    Engine.m_UseDesiredStartPoint = FALSE;
    GetGlobalVariables().ClearAllVariables();
    m_oQuestProgress.Clear();
    m_oDiscoveredCodex.Clear();
}
public native function BioGlobalVariableTable GetGlobalVariables();

public final native function bool IsDownloadableContentInitialized();

public native function InitDownloadableContent(bool bFinalAttempt, bool bBlocking);

public function Tick(float fDeltaT)
{
    local BioPlayerController PC;
    
    PC = GetLocalPlayerController();
    if (((((!bPlayersOnly && m_bAllowBrowserWheel) && !HasFocus()) && PC != None) && PC.GameModeManager2 != None) && PC.GameModeManager2.CanPause())
    {
        PC.GameModeManager2.TurnOffStormForPause();
        m_bPausedByFocusLoss = TRUE;
        bPlayersOnly = TRUE;
    }
    else if (HasFocus() && m_bPausedByFocusLoss)
    {
        m_bPausedByFocusLoss = FALSE;
        bPlayersOnly = FALSE;
    }
    if (TimerList != None)
    {
        TimerList.Tick(fDeltaT);
    }
    TickLocal(fDeltaT);
}
public native function bool HasFocus();

private final native function TickLocal(float DeltaTime);

public native function BioPlayerController GetLocalPlayerController();

public final native function bool GetCurrentStreamingChunkName(out Name nmStreamingChunkName);

public final native function PlayEndGameMusic();

public native function OverrideVFXPoolSize(BioVFXTemplate a_pEffect, int a_nMaxPoolSize, int a_nMinPoolSize);

public native function GetDefaultVFXPoolSize(BioVFXTemplate a_pEffect, out int a_rnMaxPoolSize, out int a_rnMinPoolSize);

public native function BioVisualEffectPool GetVFXPool(BioVFXTemplate pEffect);

public native function string GetDetailedVersionString();

public native function string GetEpicVersionString();

public native function string GetVersionString();

public final native function MoveToArea(Name sAreaName, Name sNextAreaStartPoint);

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
public final native function bool GetGuiInputPermission(byte nEvent);

public final event function RequestStartNewGame(optional bool bFemale, optional Name RemoteEvent)
{
    local BioPlayerController BPC;
    local MassEffectGuiManager MEGM;
    local SFXEngine Engine;
    
    if (RemoteEvent == 'None')
    {
        RemoteEvent = 're_StartNewGame';
    }
    BPC = GetLocalPlayerController();
    if (BPC == None)
    {
        return;
    }
    MEGM = MassEffectGuiManager(BPC.GetScaleFormManager());
    if (MEGM == None)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetEngine();
    Engine.bStartedGame = FALSE;
    Engine.DefaultPlayer.bIsFemale = bFemale;
    OnNewGameStartRequest(RemoteEvent);
    MEGM.ClearAll();
    MEGM.StopGuiMusic();
    MEGM.ShowBlackScreen(FALSE);
}
public native function OnNewGameStartRequest(Name RemoteEvent);

public native function bool TriggerCinematicSkippedEvent();

public final native function SetStreamingState(Name StateName, bool bValue);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDiscoveredCodexMap Name=BioDiscoveredCodex0
    End Object
    Begin Object Class=BioEventNotifier Name=BEN
    End Object
    Begin Object Class=BioGlobalVariableTable Name=BioGlobalVars0
    End Object
    Begin Object Class=BioPhysicsSounds Name=oPhysicsSound01
    End Object
    Begin Object Class=BioPowerManager Name=PowerManager
    End Object
    Begin Object Class=BioQuestProgressionMap Name=BioQuestProgress0
    End Object
    Begin Object Class=BioUIWorld Name=oUIWorld
    End Object
    Begin Template Class=PhysicsLODVerticalDestructible Name=PhysicsLODVerticalDestructible0
    End Template
    Begin Template Class=PhysicsLODVerticalEmitter Name=PhysicsLODVerticalEmitter0
    End Template
    Begin Object Class=SFXPlotTreasure Name=oPlotTreasure
    End Object
    Begin Object Class=WwiseEventPairObject Name=EndGameMusicWwiseEventPair
        Play = WwiseEvent'Wwise_Generic_Gameplay_Streaming.Play_mus_death'
        Stop = WwiseEvent'Wwise_Generic_Gameplay_Streaming.Stop_mus_death'
    End Object
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
    ConditionalClasses = ("PlotManager.BioAutoConditionals")
    EffectsMaterialPriorities = ({EffectsMaterial = 'MeltDeath', Priority = 10}, 
                                 {EffectsMaterial = 'Possession', Priority = 9}, 
                                 {EffectsMaterial = 'PowerArmor', Priority = 8}, 
                                 {EffectsMaterial = 'Cryo', Priority = 7}, 
                                 {EffectsMaterial = 'Stealth', Priority = 6}, 
                                 {EffectsMaterial = 'Fire', Priority = 5}, 
                                 {EffectsMaterial = 'Fissure', Priority = 5}, 
                                 {EffectsMaterial = 'Biotics', Priority = 4}, 
                                 {EffectsMaterial = 'Adrenaline', Priority = 3}, 
                                 {EffectsMaterial = 'Tech', Priority = 5}, 
                                 {EffectsMaterial = 'Slime', Priority = 1}, 
                                 {EffectsMaterial = 'electric', Priority = 1}
                                )
    m_oGlobalVariables = BioGlobalVars0
    m_oQuestProgress = BioQuestProgress0
    m_oDiscoveredCodex = BioDiscoveredCodex0
    m_pEndGameMusicEvent = EndGameMusicWwiseEventPair
    EventNotifier = BEN
    m_oTreasure = oPlotTreasure
    m_PhysicsSound = oPhysicsSound01
    m_UIWorld = oUIWorld
    m_oPowerManager = PowerManager
    nMemoryBudgetDLC = 1048576
    m_nJournalLastSelectedMission = -1
    m_nJournalLastSelectedAssignment = -1
    m_nCodexLastSelectedPrimary = -1
    m_nCodexLastSelectedSecondary = -1
    m_fConversationInterruptDistance = 999999.0
    m_fIdleCameraSpeed = 1.0
    m_fNoSkipBuffer = 0.699999988
    m_fLookAtNoticeMaxRange = 500.0
    m_fLookAtNoticeInitialDelay = 1.5
    m_fLookAtNoticeDuration = 6.0
    m_fLookAtNoticeSpeed = 0.200000003
    m_srProfileNotSignedInWarningMsg = $174310
    m_fMaxVFXBudget = 100.0
    m_fGameOverPauseTime = 3.0
    m_nDesignerEnableDifficultyChecksPlotFlag = -1
    m_bJournalShowingMissions = TRUE
    m_bCodexShowingPrimary = TRUE
    m_bFlushSFHud = TRUE
    m_bPartyMembersImmuneToExternalForce = TRUE
    m_bWaitingForStreamingLoadIdle = TRUE
    m_bWaitingForStreamingLoadVisibleComplete = TRUE
    bKismetShowHUD = TRUE
    m_bAllowBrowserWheel = TRUE
    DefaultPostProcessSettings = {Bloom_Scale = 0.200000003, bEnableDOF = TRUE}
    EmitterVertical = PhysicsLODVerticalEmitter0
    DestructibleVertical = PhysicsLODVerticalDestructible0
    bNoDefaultInventoryForPlayer = TRUE
}