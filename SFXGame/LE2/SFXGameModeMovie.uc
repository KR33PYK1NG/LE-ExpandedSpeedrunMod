Class SFXGameModeMovie extends SFXGameModeBase within BioPlayerController
    config(Input);

// Variables
var(SFXGameModeMovie) bool bLoadingMovie;

// Functions
public exec function ESM_SkipNonConversation()
{
    Class'ESM_LE2'.static.SkipNonConversation(Outer);
}
public function Initialize()
{
    Class'ESM_API'.static.SetupBindings(Self);
    Super.Initialize();
}
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bEnforce16x9Subtitiles = TRUE
    Priority = EGameModePriority2.ModePriority_Menus
}