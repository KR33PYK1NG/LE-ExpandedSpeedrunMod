Class SFXGameModeMovie extends SFXGameModeBase within BioPlayerController
    config(Input);

// Variables
var(SFXGameModeMovie) bool bLoadingMovie;

// Functions
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
public exec function SkipMovie()
{
    local BioWorldInfo BWI;
    local BioPlayerController PC;
    
    if (!bLoadingMovie)
    {
        BWI = BioWorldInfo(Outer.WorldInfo);
        if (BWI != None)
        {
            PC = BWI.GetLocalPlayerController();
            if ((PC != None && PC.GameModeManager2 != None) && PC.GameModeManager2.IsActive(8))
            {
                if (BWI.m_bDisableCinematicSkip == FALSE)
                {
                    BWI.m_bCinematicSkip = TRUE;
                    BWI.TriggerCinematicSkippedEvent();
                }
            }
        }
    }
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
    bEnforce16x9Subtitles = TRUE
    bRestrictToPrimaryViewport = TRUE
    Priority = EGameModePriority2.ModePriority_Menus
}