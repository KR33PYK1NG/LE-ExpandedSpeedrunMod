Class SeqAct_Interp extends SeqAct_Latent
    native;

// Types
const BioLowestPriority = 999999;
struct native BioScrubbingCamData 
{
    var Vector vCamPos;
    var Rotator rCamRot;
    var Name nmStageCam;
    var float fFov;
    var float fNearPlane;
    var float fAspectRatio;
    
    structdefaultproperties
    {
        fFov = -1234.0
    }
};
struct native CameraCutInfo 
{
    var Vector Location;
    var float TimeStamp;
};
struct native export SavedTransform 
{
    var Vector Location;
    var Rotator Rotation;
};

// Variables
var(SeqAct_Interp) array<CoverLink> LinkedCover;
var array<InterpGroupInst> GroupInst;
var transient array<CameraCutInfo> CameraCuts;
var const Class<MatineeActor> ReplicatedActorClass;
var transient BioScrubbingCamData m_tBioOriginalCam;
var transient BioScrubbingCamData m_tBioCurrentCam;
var export InterpData InterpData;
var const MatineeActor ReplicatedActor;
var(SeqAct_Interp) float PlayRate;
var float Position;
var(SeqAct_Interp) float ForceStartPosition;
var transient int nTexturesPrimed;
var(SeqAct_Interp) int PreferredSplitScreenNum;
var float TerminationTime;
var transient int m_nBioCurrentPreLoadIndex;
var transient int m_nBioScrubCamPriority;
var transient int m_nBioScrubDOFPriority;
var bool bIsPlaying;
var bool bPaused;
var transient bool bIsBeingEdited;
var(SeqAct_Interp) bool bResetPositionOnFinish;
var(SeqAct_Interp) bool bFreeAnimsetsOnFinish;
var(SeqAct_Interp) bool bLooping;
var(SeqAct_Interp) bool bRewindOnPlay;
var(SeqAct_Interp) bool bNoResetOnRewind;
var(SeqAct_Interp) bool bRewindIfAlreadyPlaying;
var bool bReversePlayback;
var(SeqAct_Interp) bool bInterpForPathBuilding;
var(SeqAct_Interp) bool bForceStartPos;
var(SeqAct_Interp) bool bClientSideOnly;
var(SeqAct_Interp) bool bSkipUpdateIfNotVisible;
var(SeqAct_Interp) bool bIsSkippable;
var(SeqAct_Interp) bool bBlockForPriming;
var transient bool bTexturesPrimed;
var transient bool bShouldShowGore;
var transient bool m_bBioPreLoadStarted;
var transient bool m_bBioIsUnderLoadingScreen;
var(SeqAct_Interp) bool bBioDryRunRequired;
var transient bool m_bBioSkipToEnd;
var transient bool m_bBioHACK_StopPinFired;
var(SeqAct_Interp) bool bDisableCulling;
var transient bool bWasCullingEnabled;
var transient bool m_bBioUseCamData;
var transient bool m_bBioSaveCamData;
var transient bool m_bBioResetCamData;
var transient byte PrimePhase;

// Functions
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}
public function Reset()
{
    SetPosition(0.0, FALSE);
    if (bActive)
    {
        InputLinks[2].bHasImpulse = TRUE;
    }
}
public final native function AddPlayerToDirectorTracks(PlayerController PC);

public final native function Stop();

public final native function SetPosition(float NewPosition, optional bool bJump = FALSE);

public native function BioScrubbingDisableDOF(int nPriority);

public native function DOFAndBloomEffect BioScrubbingGetDOF(int nPriority);

public native function BioResetScrubbingCamera();

public native function BioSetScrubbingCamera(Vector vCamPos, Rotator rCamRot, float fFov, float fNearPlane, int nPriority);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplicatedActorClass = Class'MatineeActor'
    m_tBioOriginalCam = {
                         vCamPos = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         rCamRot = {Pitch = 0, Yaw = 0, Roll = 0}, 
                         nmStageCam = 'None', 
                         fFov = -1234.0, 
                         fNearPlane = 0.0, 
                         fAspectRatio = 0.0
                        }
    m_tBioCurrentCam = {
                        vCamPos = {X = 0.0, Y = 0.0, Z = 0.0}, 
                        rCamRot = {Pitch = 0, Yaw = 0, Roll = 0}, 
                        nmStageCam = 'None', 
                        fFov = -1234.0, 
                        fNearPlane = 0.0, 
                        fAspectRatio = 0.0
                       }
    PlayRate = 1.0
    m_nBioCurrentPreLoadIndex = -1
    m_nBioScrubDOFPriority = 999999
    bBioDryRunRequired = TRUE
    InputLinks = ({
                   LinkDesc = "Play", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Reverse", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Pause", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Change Dir", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Prime Textures", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unprime Textures", 
                   LinkAction = 'None', 
                   LinkedOp = None, 
                   QueuedActivations = 0, 
                   ActivateDelay = 0.0, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Completed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Reversed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Cancelled", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stopped", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Data", 
                      ExpectedType = Class'InterpData', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Anchor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}