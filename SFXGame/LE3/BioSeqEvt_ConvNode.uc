Class BioSeqEvt_ConvNode extends SequenceEvent
    native;

// Variables
var(BioSeqEvt_ConvNode) int m_nNodeID;
var(BioSeqEvt_ConvNode) int m_nConvResRefID;

// Functions
public function Activated()
{
    local BioWorldInfo World;
    local BioConversationController ConvControl;
    local bool Ignore;
    local array<SkipRule> Rules;
    local int i;
    
    Super(SequenceOp).Activated();
    World = BioWorldInfo(GetWorldInfo());
    if (World == None || World.GetConversationManager() == None)
    {
        return;
    }
    ConvControl = World.GetConversationManager().GetFullConversation();
    if (ConvControl == None)
    {
        return;
    }
    if (ConvControl.IsCurrentlyAmbient())
    {
        Ignore = TRUE;
        Rules = Class'ESM_LE3'.default.Settings.SpecialRules;
        for (i = 0; i < Rules.Length; i++)
        {
            if (InStr(Locs(PathName(Self)), Rules[i].Path, , , ) != -1)
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
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Started", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}