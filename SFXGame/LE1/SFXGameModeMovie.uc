Class SFXGameModeMovie extends SFXGameModeBase within BioPlayerController
    config(Input);

// Variables
var(SFXGameModeMovie) export SFXCameraMode_Cinematic ExploreCam;
var(SFXGameModeMovie) export SFXCameraTransition_GalaxyMap InstantTransition;
var(SFXGameModeMovie) bool bLoadingMovie;

// Functions
public exec function SkipMovie()
{
    if (bLoadingMovie == FALSE)
    {
        Class'SFXEngine'.static.SkipMovie();
    }
}
public function Deactivated()
{
    Super.Deactivated();
    bLoadingMovie = FALSE;
}
public function ActivateSpecifier(Name ModeSpecifier)
{
    if (ModeSpecifier == 'LoadingMovie')
    {
        bLoadingMovie = TRUE;
    }
    Super.ActivateSpecifier(ModeSpecifier);
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    Transition = InstantTransition;
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return ExploreCam;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Cinematic Name=CineCam0
        CameraName = 'MovieExploreCam'
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    ExploreCam = CineCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "Console_MovieSkip", 
                 Name = 'XboxTypeS_X', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_MovieSkip", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_MovieSkip", 
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
    Priority = EGameModePriority.ModePriority_Menus
}