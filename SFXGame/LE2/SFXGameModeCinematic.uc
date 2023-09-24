Class SFXGameModeCinematic extends SFXGameModeBase within BioPlayerController
    config(Input);

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
public exec function SkipCinematic()
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (BWI != None && BWI.m_bDisableCinematicSkip == FALSE)
    {
        BWI.m_bCinematicSkip = TRUE;
        BWI.TriggerCinematicSkippedEvent();
    }
    else
    {
        Outer.GetScaleFormManager().PlayGuiSound('CinematicSkipError');
    }
}
public function Deactivated()
{
    Super.Deactivated();
}
public function Activated()
{
    local Actor A;
    local SFXSelectionModule SelMod;
    
    Super.Activated();
    Outer.m_oPlayerSelection.SelectionFlareComp.SetHidden(TRUE);
    foreach BioWorldInfo(Outer.WorldInfo).SelectableActors(A, )
    {
        SelMod = A.GetModule(Class'SFXSelectionModule');
        if (SelMod != None && SelMod.LensFlareComp != None)
        {
            SelMod.LensFlareComp.SetHidden(TRUE);
        }
    }
    RemoveTimeDilationEffects();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bindings = ({
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
    bShowSubtitle = TRUE
    bHasMouseAuthority = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bEnforce16x9Subtitiles = TRUE
}