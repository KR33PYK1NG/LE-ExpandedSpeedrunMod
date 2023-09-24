Class BioSeqAct_BioToggleCinematicMode extends SeqAct_ToggleCinematicMode;

// Variables
var(BioSeqAct_BioToggleCinematicMode) string sSkipEvent;
var(BioSeqAct_BioToggleCinematicMode) bool bCinematicInputMode;
var(BioSeqAct_BioToggleCinematicMode) bool bDisableCinematicSkip;
var(BioSeqAct_BioToggleCinematicMode) bool m_bEnterCombatModeOnEnd;

// Functions
public function Activated()
{
    local BioWorldInfo oBioInfo;
    local BioPlayerController oPlayerController;
    local BioPlayerInput pInput;
    local SFXPawn_Player pPlayer;
    
    oBioInfo = BioWorldInfo(GetWorldInfo());
    oPlayerController = oBioInfo.GetLocalPlayerController();
    oPlayerController.OnToggleCinematicMode(Self);
    if (oPlayerController.bCinematicMode)
    {
        Class'ESM_API'.static.StartTarget(PathName(Self), oBioInfo.TimeSeconds, 3);
    }
    if (bCinematicInputMode)
    {
        oBioInfo.Game.SetGameSpeed(1.0);
        oBioInfo.m_bCinematicSkip = FALSE;
        oBioInfo.m_bDisableCinematicSkip = bDisableCinematicSkip;
        oBioInfo.m_sCinematicSkipEvent = sSkipEvent;
        oBioInfo.SetRenderStateOfPlayerToDefault(0);
        if (!oPlayerController.bCinematicMode)
        {
            if (oPlayerController != None && m_bEnterCombatModeOnEnd)
            {
                pInput = BioPlayerInput(oPlayerController.PlayerInput);
                pPlayer = SFXPawn_Player(oPlayerController.Pawn);
                if ((pInput != None && pInput.IsCombatEnabled()) && pPlayer.m_oBehavior != None)
                {
                    pPlayer.SetCombatState(TRUE);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCinematicInputMode = TRUE
    m_bEnterCombatModeOnEnd = TRUE
}