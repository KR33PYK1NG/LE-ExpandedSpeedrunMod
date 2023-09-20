Class SFXGameModeCinematic extends SFXGameModeBase within BioPlayerController
    config(Input);

// Variables
var(SFXGameModeCinematic) export SFXCameraMode_Cinematic ExploreCam;
var(SFXGameModeCinematic) export SFXCameraMode_Cinematic CombatCam;
var(SFXGameModeCinematic) export SFXCameraMode_Cinematic VehicleCam;
var(SFXGameModeCinematic) export SFXCameraTransition_GalaxyMap InstantTransition;
var config float CinematicSkipDelay;
var config bool bCineFastForwardEnabled;
var config bool bEnableCinematicSkip;

// Functions
public exec function ESM_SkipNonConversation()
{
    Class'ESM_LE1'.static.SkipNonConversation(Outer);
}
public function Initialize()
{
    Class'ESM_API'.static.SetupBindings(Self);
    Super.Initialize();
}
public exec function SkipCinematic()
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (((bEnableCinematicSkip && BWI != None) && BWI.m_bDisableCinematicSkip == FALSE) && Outer.WorldInfo.TimeSeconds - BWI.m_fCinematicStartTime >= CinematicSkipDelay)
    {
        BWI.m_bCinematicSkip = TRUE;
        BWI.TriggerCinematicSkippedEvent();
    }
    else
    {
        Outer.GetScaleFormManager().PlayGuiSound('CinematicSkipError');
    }
}
public exec function CinematicFF(bool bOn)
{
    if (bCineFastForwardEnabled)
    {
        if (bOn)
        {
            Outer.WorldInfo.Game.SetGameSpeed(6.0);
        }
        else
        {
            Outer.WorldInfo.Game.SetGameSpeed(1.0);
        }
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    local BioPawn MyBP;
    local BioVehicleBase Vehicle;
    
    Transition = InstantTransition;
    TransitionTime = 0.0;
    PreserveTarget = 0;
    MyBP = BioPawn(Outer.Pawn);
    if (MyBP != None)
    {
        if (MyBP.IsInCombatActionState())
        {
            return CombatCam;
        }
        else
        {
            return ExploreCam;
        }
    }
    else
    {
        Vehicle = BioVehicleBase(Outer.Pawn);
        if (Vehicle != None)
        {
            return VehicleCam;
        }
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Cinematic Name=CineCam0
        Offset = {X = 200.0, Y = 0.0, Z = 40.0}
        HookOffset = {X = 0.0, Y = 0.0, Z = 120.0}
        CameraName = 'CineExploreCam'
        bInstantTransition = TRUE
    End Object
    Begin Object Class=SFXCameraMode_Cinematic Name=CineCam1
        Offset = {X = 80.0, Y = -44.0, Z = 15.0}
        HookOffset = {X = -30.0, Y = 0.0, Z = 80.0}
        CameraName = 'CineCombatCam'
        FOV = 70.0
        bInstantTransition = TRUE
    End Object
    Begin Object Class=SFXCameraMode_Cinematic Name=CineCam2
        Offset = {X = 1100.0, Y = 0.0, Z = 0.0}
        HookOffset = {X = 0.0, Y = 0.0, Z = 350.0}
        CameraName = 'CineVehicleCam'
        FOV = 70.0
        bInstantTransition = TRUE
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    ExploreCam = CineCam0
    CombatCam = CineCam1
    VehicleCam = CineCam2
    InstantTransition = InstantTransition0
    CinematicSkipDelay = 1.0
    Bindings = ({
                 Command = "Console_CineFastForward", 
                 Name = 'XboxTypeS_A', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Console_CineSkip", 
                 Name = 'XboxTypeS_X', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Console_CineSkip", 
                 Name = 'XboxTypeS_B', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_CineFastForward", 
                 Name = 'LeftControl', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_CineSkip", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_CineSkip", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bAllowPlayerRotation = TRUE
    bAllowAIMovement = FALSE
    bAllowHenchmenMovement = FALSE
    bAllowLookAt = FALSE
    bHasMouseAuthority = TRUE
}