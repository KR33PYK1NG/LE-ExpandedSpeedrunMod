Class BioSFHandler_Conversation extends BioSFHandler
    native
    transient
    config(UI);

// Types
const INVESTIGATE_OPTION = -3;
const RETURN_OPTION = -2;
const UNUSED_SLOT = -1;
const InitializationComplete = 7;
const SelectParagonInterrupt = 6;
const SelectRenegadeInterrupt = 5;
const QueueEntry = 4;
const ShowReplyWheel = 3;
const SelectEntry = 2;
const SkipNode = 1;
enum BioConvWheelPositions
{
    REPLY_WHEEL_MIDDLE_RIGHT,
    REPLY_WHEEL_BOTTOM_RIGHT,
    REPLY_WHEEL_BOTTOM_LEFT,
    REPLY_WHEEL_MIDDLE_LEFT,
    REPLY_WHEEL_TOP_LEFT,
    REPLY_WHEEL_TOP_RIGHT,
};
const MODE_Illegal = 4;
const MODE_Intimidate = 3;
const MODE_Charm = 2;
const MODE_Investigate = 1;
const MODE_None = 0;

// Variables
var int m_aReplyLocations[6];
var int m_aInvestigateLocations[6];
var int m_nSlotsUsed[6];
var Vector vInput;
var config stringref m_srTextInvestigate;
var config stringref m_srTextReturn;
var config int m_nReplyLocationMiddleLeft;
var config int m_nReplyLocationTopLeft;
var config int m_nReplyLocationBottomLeft;
var config int m_nReplyLocationTopRight;
var config int m_nReplyLocationBottomRight;
var config int m_nReplyLocationMiddleRight;
var config int m_nInvestigateLocationMiddleLeft;
var config int m_nInvestigateLocationTopLeft;
var config int m_nInvestigateLocationBottomLeft;
var config int m_nInvestigateLocationTopRight;
var config int m_nInvestigateLocationBottomRight;
var config int m_nInvestigateLocationMiddleRight;
var float fLastRadius;
var bool m_bDisplayInvestigateSubMenu;
var bool m_bDisplayingWheel;
var bool m_bDisplayingParagonInterrupt;
var bool m_bDIsplayingRenegadeInterrupt;
var transient bool m_bSFScreenInitialized;
var transient bool m_bWasTriggered;

// Functions
public final event function bool IsVisible()
{
    return m_bDisplayingWheel || m_bDisplayInvestigateSubMenu;
}
public final event function SetVisible(bool bVal)
{
    if (!bVal)
    {
        m_bDisplayInvestigateSubMenu = FALSE;
        m_bDisplayingWheel = FALSE;
    }
}
public final function int GetInvestigateReplyCount(BioConversation oConversation)
{
    local int nCount;
    local int I;
    
    if (oConversation == None)
    {
        return 0;
    }
    nCount = 0;
    for (I = 0; I < GetNumReplies(oConversation); I++)
    {
        if (oConversation.GetReplyCategory(I) == 5)
        {
            nCount++;
        }
    }
    return nCount;
}
public final function BioConvWheelPositions GetReplyLocation(int nReplyCategory)
{
    local int I;
    
    for (I = 0; I < 6; I++)
    {
        if (nReplyCategory == m_aReplyLocations[I] || I == 6 - 1)
        {
            if (m_nSlotsUsed[I] == -1)
            {
                return byte(I);
                continue;
            }
            return 6;
        }
    }
    return 6;
}
public final function BioConvWheelPositions GetInvestigateReplyLocation(int nInvestigateSlot)
{
    local int I;
    local int J;
    
    for (I = nInvestigateSlot; I < 6; I++)
    {
        for (J = 0; J < 6; J++)
        {
            if (m_aInvestigateLocations[J] == I)
            {
                if (m_nSlotsUsed[J] == -1)
                {
                    return byte(J);
                }
                break;
            }
        }
    }
    return 6;
}
public final function bool SelectConversationEntry(BioConvWheelPositions nWheelLocation)
{
    local BioWorldInfo oBioWorldInfo;
    local BioConversation oConversation;
    local bool bChangingMenu;
    local int nReplyIndex;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    oConversation = oBioWorldInfo.GetConversation();
    bChangingMenu = FALSE;
    nReplyIndex = m_nSlotsUsed[int(nWheelLocation)];
    if (nReplyIndex >= 0)
    {
        if (int(oConversation.GetReplyGUIStyle(nReplyIndex)) == 4)
        {
            PlayGuiSound('ConvError');
            return FALSE;
        }
        m_bDisplayInvestigateSubMenu = FALSE;
        PlayGuiSound('ConvSelect');
        if (oConversation.QueueReply(nReplyIndex) == FALSE)
        {
            oBioWorldInfo.EndCurrentConversation();
        }
    }
    else if (nReplyIndex == -2 && m_bDisplayInvestigateSubMenu)
    {
        m_bDisplayInvestigateSubMenu = FALSE;
        bChangingMenu = TRUE;
    }
    else if (nReplyIndex == -3 && !m_bDisplayInvestigateSubMenu)
    {
        m_bDisplayInvestigateSubMenu = TRUE;
        bChangingMenu = TRUE;
    }
    else
    {
        PlayGuiSound('ConvError');
    }
    if (bChangingMenu)
    {
        UpdateConversationOptions(oConversation);
    }
    return !bChangingMenu;
}
public final function int MapGuiStyleToOptionMode(EConvGUIStyles eGUIStyle)
{
    local int nMode;
    
    nMode = 0;
    switch (eGUIStyle)
    {
        case EConvGUIStyles.GUI_STYLE_CHARM:
            nMode = 2;
            break;
        case EConvGUIStyles.GUI_STYLE_INTIMIDATE:
            nMode = 3;
            break;
        case EConvGUIStyles.GUI_STYLE_ILLEGAL:
            nMode = 4;
            break;
        default:
    }
    return nMode;
}
public final function UpdateConversationOptions(BioConversation oConversation)
{
    local string sConversationOptions[6];
    local int nConversationOptionModes[6];
    local BioConvWheelPositions ePosition;
    local int I;
    local int nInvestigateReplyCount;
    local int nInvestigateReplyIteration;
    local int nReplyCategory;
    local stringref srOption;
    local bool bDisplayReply;
    local bool bFirstInvestigateFound;
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    nInvestigateReplyCount = GetInvestigateReplyCount(oConversation);
    for (I = 0; I < 6; I++)
    {
        m_nSlotsUsed[I] = -1;
    }
    for (I = 0; I < GetNumReplies(oConversation); I++)
    {
        srOption = $0;
        bDisplayReply = FALSE;
        nReplyCategory = oConversation.GetReplyCategory(I);
        if (m_bDisplayInvestigateSubMenu)
        {
            if (nReplyCategory == 5)
            {
                bDisplayReply = TRUE;
            }
        }
        else if (nReplyCategory == 5)
        {
            if (!bFirstInvestigateFound)
            {
                bDisplayReply = TRUE;
                bFirstInvestigateFound = TRUE;
                nInvestigateReplyIteration = 0;
                if (nInvestigateReplyCount > 1)
                {
                    srOption = m_srTextInvestigate;
                }
            }
        }
        else
        {
            bDisplayReply = TRUE;
        }
        if (bDisplayReply)
        {
            ePosition = 6;
            if (m_bDisplayInvestigateSubMenu)
            {
                if (nInvestigateReplyIteration < 0)
                {
                    nInvestigateReplyIteration = 0;
                }
                if (nReplyCategory == 5)
                {
                    nInvestigateReplyIteration++;
                    ePosition = GetInvestigateReplyLocation(nInvestigateReplyIteration);
                }
            }
            else
            {
                ePosition = GetReplyLocation(nReplyCategory);
            }
            if (int(ePosition) != 6)
            {
                if (srOption == 0)
                {
                    sConversationOptions[int(ePosition)] = oConversation.GetReplyParaphraseText(I);
                    nConversationOptionModes[int(ePosition)] = MapGuiStyleToOptionMode(oConversation.GetReplyGUIStyle(I));
                    m_nSlotsUsed[int(ePosition)] = I;
                    continue;
                }
                sConversationOptions[int(ePosition)] = string(srOption);
                nConversationOptionModes[int(ePosition)] = 1;
                m_nSlotsUsed[int(ePosition)] = -3;
            }
        }
    }
    if (m_bDisplayInvestigateSubMenu)
    {
        ePosition = GetInvestigateReplyLocation(0);
        if (int(ePosition) != 6)
        {
            sConversationOptions[int(ePosition)] = string(m_srTextReturn);
            m_nSlotsUsed[int(ePosition)] = -2;
        }
    }
    for (I = 0; I < 6; I++)
    {
        stParam.Type = ASParamTypes.ASParam_String;
        stParam.sVar = sConversationOptions[I];
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_Integer;
        stParam.nVar = nConversationOptionModes[I];
        lstParams.AddItem(stParam);
    }
    oPanel.InvokeMethodArgs("setConversationOptions", lstParams);
}
public function Update(float fDeltaT)
{
    local BioWorldInfo oBioWorldInfo;
    local BioConversation oConversation;
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    oConversation = oBioWorldInfo.m_oCurrentConversation;
    if (oConversation != None && oConversation.NeedToDisplayReplies())
    {
        if (m_bDisplayingWheel == FALSE)
        {
            UpdateConversationOptions(oConversation);
            m_bDisplayingWheel = TRUE;
        }
        stParam.Type = ASParamTypes.ASParam_Integer;
        CalculateArrowPosition(stParam, lstParams);
        lstParams.Length = 0;
    }
    else if (m_bDisplayingWheel)
    {
        m_bDisplayingWheel = FALSE;
        oPanel.InvokeMethod("HideWheel");
    }
    UpdateInterruptVisuals(oConversation);
}
public function CalculateArrowPosition(out ASParams stParam, out array<ASParams> lstParams)
{
    local float fRadius;
    local Rotator R;
    
    if (Abs(vInput.X) > 0.25 || Abs(vInput.Y) > 0.25)
    {
        fRadius = Square(vInput.X) + Square(vInput.Y);
        if (fRadius >= fLastRadius || fRadius > 0.899999976)
        {
            R = Rotator(vInput);
            stParam.nVar = int(float(R.Yaw) * 0.00549316406);
            if (stParam.nVar < 0)
            {
                stParam.nVar += 360;
            }
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("setArrowPosition", lstParams);
        }
        fLastRadius = fRadius;
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild() || oPanel.bUsingGamepad)
    {
        stParam.nVar = 360;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("setArrowPosition", lstParams);
        fLastRadius = 0.0;
    }
}
public function UpdateInterruptVisuals(BioConversation oConversation)
{
    local bool bDisplayRenegade;
    local bool bDisplayParagon;
    
    bDisplayRenegade = FALSE;
    bDisplayParagon = FALSE;
    if (oConversation != None)
    {
        if (oConversation.NeedToDisplayInterrupt())
        {
            switch (oConversation.m_tInterruptInfo.eInterruptType)
            {
                case EInterruptionType.INTERRUPTION_RENEGADE:
                    bDisplayRenegade = TRUE;
                    break;
                case EInterruptionType.INTERRUPTION_PARAGON:
                    bDisplayParagon = TRUE;
                    break;
                default:
            }
        }
    }
    if (bDisplayRenegade != m_bDIsplayingRenegadeInterrupt)
    {
        oPanel.InvokeMethod(bDisplayRenegade ? "showRenegadeInterrupt" : "hideRenegadeInterrupt");
        m_bDIsplayingRenegadeInterrupt = bDisplayRenegade;
        if (!m_bWasTriggered)
        {
            PlayGuiSound(bDisplayRenegade ? 'InterruptAppearRenegade' : 'InterruptDisappear');
        }
        m_bWasTriggered = FALSE;
    }
    if (bDisplayParagon != m_bDisplayingParagonInterrupt)
    {
        oPanel.InvokeMethod(bDisplayParagon ? "showParagonInterrupt" : "hideParagonInterrupt");
        m_bDisplayingParagonInterrupt = bDisplayParagon;
        if (!m_bWasTriggered)
        {
            PlayGuiSound(bDisplayParagon ? 'InterruptAppearParagon' : 'InterruptDisappear');
        }
        m_bWasTriggered = FALSE;
    }
}
public function HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            vInput.Y = fValue;
            break;
        default:
            Super.HandleInputEvent(Event, fValue);
    }
}
public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    local BioWorldInfo oBioWorldInfo;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    if (oBioWorldInfo.m_oCurrentConversation == None)
    {
        return;
    }
    switch (nCommand)
    {
        case 1:
            if (oBioWorldInfo.m_oCurrentConversation.SkipNode() == FALSE)
            {
                PlayGuiSound('ConvError');
            }
            break;
        case 2:
            if (SelectConversationEntry(byte(int(lstArguments[0]))))
            {
                if (oBioWorldInfo.m_oCurrentConversation.SkipNode() == FALSE)
                {
                    PlayGuiSound('ConvError');
                }
            }
            break;
        case 3:
            oBioWorldInfo.m_oCurrentConversation.m_bForceShowReplies = TRUE;
            break;
        case 4:
            SelectConversationEntry(byte(int(lstArguments[0])));
            break;
        case 6:
            PlayGuiSound('InterruptTriggeredParagon');
            oBioWorldInfo.m_oCurrentConversation.SelectInterruption();
            m_bWasTriggered = TRUE;
            break;
        case 5:
            PlayGuiSound('InterruptTriggeredRenegade');
            oBioWorldInfo.m_oCurrentConversation.SelectInterruption();
            m_bWasTriggered = TRUE;
            break;
        case 7:
            m_bSFScreenInitialized = TRUE;
            break;
        default:
    }
}
public function OnPanelRemoved()
{
    Super.OnPanelRemoved();
    fLastRadius = 0.0;
    m_bDisplayInvestigateSubMenu = FALSE;
    m_bDisplayingWheel = FALSE;
}
public function OnPanelAdded()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    Super.OnPanelAdded();
    m_aReplyLocations[0] = m_nReplyLocationMiddleRight;
    m_aReplyLocations[1] = m_nReplyLocationBottomRight;
    m_aReplyLocations[2] = m_nReplyLocationBottomLeft;
    m_aReplyLocations[3] = m_nReplyLocationMiddleLeft;
    m_aReplyLocations[4] = m_nReplyLocationTopLeft;
    m_aReplyLocations[5] = m_nReplyLocationTopRight;
    m_aInvestigateLocations[0] = m_nInvestigateLocationMiddleRight;
    m_aInvestigateLocations[1] = m_nInvestigateLocationBottomRight;
    m_aInvestigateLocations[2] = m_nInvestigateLocationBottomLeft;
    m_aInvestigateLocations[3] = m_nInvestigateLocationMiddleLeft;
    m_aInvestigateLocations[4] = m_nInvestigateLocationTopLeft;
    m_aInvestigateLocations[5] = m_nInvestigateLocationTopRight;
    oPanel.bUseThumbstickAsDPad = FALSE;
    m_bDIsplayingRenegadeInterrupt = FALSE;
    m_bDisplayingParagonInterrupt = FALSE;
    oPanel.bIgnoreGCOnPanelCleanup = TRUE;
    oPanel.SetInputDisabled(TRUE);
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = int(ScreenLayout);
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("SetPlatformLayout", lstParams);
}
public final function int GetNumReplies(BioConversation oConversation)
{
    return oConversation.m_lstCurrentReplyIndices.Length;
}
public final function InterruptRenegade()
{
    oPanel.InvokeMethod("InteruptRenegade");
}
public final function InterruptParagon()
{
    oPanel.InvokeMethod("InteruptParagon");
}
public final function SkipConversation()
{
    oPanel.InvokeMethod("SelectOrSkipConversation");
}
public final function SelectConversationSegment()
{
    oPanel.InvokeMethod("SelectConversationSegment");
}
public function HighlightDefaultConvSegment();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_srTextInvestigate = $122746
    m_srTextReturn = $122747
    m_nReplyLocationMiddleLeft = 5
    m_nReplyLocationTopLeft = 3
    m_nReplyLocationBottomLeft = 4
    m_nReplyLocationTopRight = 1
    m_nReplyLocationBottomRight = 2
    m_nInvestigateLocationMiddleLeft = 3
    m_nInvestigateLocationTopLeft = 2
    m_nInvestigateLocationBottomLeft = 1
    m_nInvestigateLocationTopRight = 5
    m_nInvestigateLocationBottomRight = 4
    nHandlerID = 5
    bSetGameMode = FALSE
}