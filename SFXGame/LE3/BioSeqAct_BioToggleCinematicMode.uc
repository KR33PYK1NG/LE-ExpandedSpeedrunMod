Class BioSeqAct_BioToggleCinematicMode extends SeqAct_ToggleCinematicMode;

// Variables
var(BioSeqAct_BioToggleCinematicMode) string sSkipEvent;
var(BioSeqAct_BioToggleCinematicMode) bool bCinematicInputMode;
var(BioSeqAct_BioToggleCinematicMode) bool bDisableCinematicSkip;
var(BioSeqAct_BioToggleCinematicMode) bool m_bSupportsPlayerHelmet;
var(BioSeqAct_BioToggleCinematicMode) bool m_bSupportsPlayerFace;

// Functions
public function Activated()
{
    ToggleCineMode();
}
public function ToggleCineMode()
{
    local BioWorldInfo oBioInfo;
    local BioPlayerController oPlayerController;
    local string sMessage;
    local string sPathName;
    
    sMessage = "Toggle Cinematic Mode kismet fired from this location: ";
    sPathName = PathName(Self);
    if (InStr(sPathName, "transient", FALSE, TRUE, ) >= 0)
    {
        sMessage = sMessage $ "'automatically disabled by conversation'";
    }
    else
    {
        sMessage = sMessage $ sPathName;
    }
    if (InputLinks[0].bHasImpulse)
    {
        sMessage = sMessage $ ". 'Enable' pin pulsed";
    }
    else if (InputLinks[1].bHasImpulse)
    {
        sMessage = sMessage $ ". 'Disable' pin pulsed";
    }
    else if (InputLinks[2].bHasImpulse)
    {
        sMessage = sMessage $ ". 'Toggle' pin pulsed";
    }
    else
    {
        sMessage = sMessage $ ". UNKNOWN or NO pin pulsed";
    }
    LogInternal(sMessage, 'WorldFrames');
    oBioInfo = BioWorldInfo(GetWorldInfo());
    if (oBioInfo != None)
    {
        oPlayerController = oBioInfo.GetLocalPlayerController();
        if (oPlayerController != None)
        {
            oPlayerController.OnToggleCinematicMode(Self);
            if (oPlayerController.bCinematicMode)
            {
                Class'ESM_API'.static.StartTarget(PathName(Self), oBioInfo.TimeSeconds, 3);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCinematicInputMode = TRUE
    m_bSupportsPlayerHelmet = TRUE
    m_bSupportsPlayerFace = TRUE
}