Class BioSeqEvt_ConvNode extends SequenceEvent
    native;

// Variables
var(BioSeqEvt_ConvNode) int m_nNodeID;
var(BioSeqEvt_ConvNode) int m_nConvResRefID;
var transient bool m_bSetWaitFlags;

// Functions
public function Activated()
{
    local BioWorldInfo World;
    local BioConversation Conv;
    local bool Ignore;
    local array<SkipRule> Rules;
    local int I;
    
    Super(SequenceOp).Activated();
    World = BioWorldInfo(GetWorldInfo());
    if (World == None)
    {
        return;
    }
    Conv = World.GetConversation();
    if (Conv == None)
    {
        return;
    }
    if (Conv.IsAmbient())
    {
        Ignore = TRUE;
        Rules = Class'ESM_LE2'.default.Settings.SpecialRules;
        for (I = 0; I < Rules.Length; I++)
        {
            if (InStr(Locs(PathName(Self)), Rules[I].Path, , , ) != -1)
            {
                Ignore = FALSE;
                break;
            }
        }
        if (Ignore)
        {
            return;
        }
    }
    Class'ESM_API'.static.StartTarget(PathName(Self), ActivationTime, Class'ESM_API'.default.LastConvId != m_nConvResRefID ? 2 : 0);
    Class'ESM_API'.default.LastConvId = m_nConvResRefID;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nNodeID = -1
    m_nConvResRefID = -1
    m_bSetWaitFlags = TRUE
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Started", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}