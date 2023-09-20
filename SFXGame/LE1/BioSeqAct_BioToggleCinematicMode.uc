Class BioSeqAct_BioToggleCinematicMode extends SeqAct_ToggleCinematicMode;

// Variables
var(BioSeqAct_BioToggleCinematicMode) string sSkipEvent;
var(BioSeqAct_BioToggleCinematicMode) bool bCinematicInputMode;
var(BioSeqAct_BioToggleCinematicMode) bool bDisableCinematicSkip;

// Functions
public function Activated()
{
    local BioWorldInfo oBioInfo;
    local BioPlayerController oPlayerController;
    local BioEpicPawnBehavior oBehavior;
    local BioPawn oHenchmanBioPawn;
    local int Cnt;
    local BioPawn oPlayerPawn;
    local bool bForceOn;
    local bool bForceOff;
    
    bForceOn = InputLinks[0].bHasImpulse;
    bForceOff = InputLinks[1].bHasImpulse;
    oBioInfo = BioWorldInfo(GetWorldInfo());
    oPlayerController = oBioInfo.GetLocalPlayerController();
    if (!(oPlayerController.bCinematicMode && bForceOn || !oPlayerController.bCinematicMode && bForceOff))
    {
        oPlayerController.OnToggleCinematicMode(Self);
        if (oPlayerController.bCinematicMode)
        {
            Class'ESM_API'.static.StartTarget(PathName(Self), oBioInfo.TimeSeconds, 3);
        }
        LogInternal("Toggling cinematic mode...", );
    }
    else if (bForceOn)
    {
        LogInternal("Forcing cinematic mode on when it's already on!", );
    }
    else
    {
        LogInternal("Forcing cinematic mode off when it's already off!", );
    }
    if (bCinematicInputMode)
    {
        oBioInfo.Game.SetGameSpeed(1.0);
        oBioInfo.m_bCinematicSkip = FALSE;
        oBioInfo.m_bDisableCinematicSkip = bDisableCinematicSkip;
        oBioInfo.m_sCinematicSkipEvent = sSkipEvent;
        oBioInfo.m_fCinematicStartTime = oBioInfo.TimeSeconds;
        oBioInfo.ClearResetBehaviors();
        oPlayerPawn = BioPawn(oPlayerController.Pawn);
        if (oPlayerController.bCinematicMode)
        {
            if (oPlayerController.GameModeManager.IsActive(6) == FALSE)
            {
                oPlayerController.GameModeManager.EnableMode(6);
                if (oPlayerPawn != None)
                {
                    oPlayerPawn.m_oBehavior.RecoverFromBleedOut();
                }
                for (Cnt = 1; Cnt < oBioInfo.m_playerSquad.GetSquadSize(); Cnt++)
                {
                    oHenchmanBioPawn = BioPawn(oBioInfo.m_playerSquad.GetMember(Cnt));
                    oBehavior = BioEpicPawnBehavior(oHenchmanBioPawn.oBioComponent);
                    oBehavior.AbilityEnable(FALSE, 0, 'All');
                }
                oPlayerController.LogCinematicMode(TRUE);
            }
        }
        else if (oPlayerController.GameModeManager.IsActive(6))
        {
            oPlayerController.GameModeManager.DisableMode(6);
            oPlayerController.DisableDOF();
            for (Cnt = 1; Cnt < oBioInfo.m_playerSquad.GetSquadSize(); Cnt++)
            {
                oHenchmanBioPawn = BioPawn(oBioInfo.m_playerSquad.GetMember(Cnt));
                oBehavior = BioEpicPawnBehavior(oHenchmanBioPawn.oBioComponent);
                oBehavior.AbilityEnable(TRUE, 0, 'All');
                if (BioAiController(oHenchmanBioPawn.Controller) != None)
                {
                    BioAiController(oHenchmanBioPawn.Controller).PushFollowSquadLeader();
                }
            }
            oBioInfo.StartNoBrowserWheelTimer();
            oPlayerController.LogCinematicMode(FALSE);
        }
        oBioInfo.SetRenderStateOfPlayerToDefault(0);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCinematicInputMode = TRUE
}