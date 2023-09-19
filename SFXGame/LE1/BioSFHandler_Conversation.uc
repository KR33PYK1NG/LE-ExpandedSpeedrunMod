Class BioSFHandler_Conversation extends BioSFHandler
    transient
    config(UI);

// Types
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
var string m_szLastSubtitleText;
var int m_aReplyLocations[6];
var int m_aInvestigateLocations[6];
var Vector vMouseInput;
var Vector vInput;
var BioSubtitles m_oLastSubtitle;
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
var config float AccumulationDivisor;
var bool m_bDisplayInvestigateSubMenu;
var bool m_bDisplayingWheel;
var byte m_bSlotsUsed[6];

// Functions
public final function bool ChangeConversationMenu(BioConversation oConversation, int nReplyIndex)
{
    local int nReplyCategory;
    
    if (oConversation == None)
    {
        return FALSE;
    }
    if (nReplyIndex < 0 || nReplyIndex >= GetNumReplies(oConversation))
    {
        return FALSE;
    }
    nReplyCategory = oConversation.GetReplyCategory(nReplyIndex);
    if (!m_bDisplayInvestigateSubMenu)
    {
        if (nReplyCategory == 5)
        {
            if (GetInvestigateReplyCount(oConversation) > 1)
            {
                m_bDisplayInvestigateSubMenu = TRUE;
                return TRUE;
            }
        }
    }
    else if (nReplyCategory == 0)
    {
        m_bDisplayInvestigateSubMenu = FALSE;
        return TRUE;
    }
    return FALSE;
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
            if (int(m_bSlotsUsed[I]) == 0)
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
                if (int(m_bSlotsUsed[J]) == 0)
                {
                    return byte(J);
                }
                break;
            }
        }
    }
    return 6;
}
public final function int GetInvestigateReplyFromWheelLocation(BioConversation oConversation, BioConvWheelPositions nWheelLocation)
{
    local int nReplyIndex;
    local int nInvestigateIndex;
    local int nMainmenuIndex;
    local int nCategory;
    local int nReplies;
    local int nInvestigates;
    local int I;
    local int nUnshiftLimit;
    
    nReplies = GetNumReplies(oConversation);
    nInvestigates = 0;
    nUnshiftLimit = 0;
    for (I = 0; I < nReplies; I++)
    {
        nCategory = oConversation.GetReplyCategory(I);
        if (nCategory == 5)
        {
            nInvestigates++;
            continue;
        }
        if (nCategory == 0)
        {
            nUnshiftLimit = nInvestigates;
            nInvestigates++;
            nMainmenuIndex = I;
        }
    }
    nReplyIndex = -1;
    nInvestigateIndex = -2;
    if (m_aInvestigateLocations[int(nWheelLocation)] < nInvestigates)
    {
        nInvestigateIndex = m_aInvestigateLocations[int(nWheelLocation)];
    }
    if (nUnshiftLimit >= nInvestigateIndex)
    {
        nInvestigateIndex--;
    }
    for (I = 0; I < nReplies && nInvestigateIndex > -1; I++)
    {
        nCategory = oConversation.GetReplyCategory(I);
        if (nCategory == 5)
        {
            nInvestigateIndex--;
            nReplyIndex = I;
            continue;
        }
        if (nCategory == 0)
        {
            nInvestigateIndex--;
        }
    }
    if (nReplyIndex == -1 && nInvestigateIndex > -2)
    {
        nReplyIndex = nMainmenuIndex;
    }
    return nReplyIndex;
}
public final function bool SelectConversationEntry(BioConvWheelPositions nWheelLocation)
{
    local BioWorldInfo oBioWorldInfo;
    local BioConversation oConversation;
    local bool bChangingMenu;
    local int I;
    local int nReplyIndex;
    local int nReplyCategory;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    oConversation = oBioWorldInfo.GetConversation();
    bChangingMenu = FALSE;
    if (m_bDisplayInvestigateSubMenu)
    {
        nReplyIndex = GetInvestigateReplyFromWheelLocation(oConversation, nWheelLocation);
    }
    else
    {
        nReplyCategory = m_aReplyLocations[int(nWheelLocation)];
        for (I = 0; I < GetNumReplies(oConversation); I++)
        {
            if (oConversation.GetReplyCategory(I) == nReplyCategory)
            {
                nReplyIndex = I;
                break;
            }
        }
    }
    if (nReplyIndex != -1)
    {
        if (int(oConversation.GetReplyGUIStyle(nReplyIndex)) == 4)
        {
            PlayGuiSound('ConvError');
            return FALSE;
        }
        if (ChangeConversationMenu(oConversation, nReplyIndex))
        {
            UpdateConversationOptions(oConversation);
            bChangingMenu = TRUE;
        }
        else
        {
            m_bDisplayInvestigateSubMenu = FALSE;
        }
        PlayGuiSound('ConvSelect');
        if (bChangingMenu == FALSE && oConversation.QueueReply(nReplyIndex) == FALSE)
        {
            oBioWorldInfo.EndCurrentConversation();
        }
    }
    else
    {
        PlayGuiSound('ConvError');
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
        m_bSlotsUsed[I] = 0;
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
                }
                else
                {
                    sConversationOptions[int(ePosition)] = string(srOption);
                    nConversationOptionModes[int(ePosition)] = 1;
                }
                m_bSlotsUsed[int(ePosition)] = 1;
            }
        }
    }
    if (m_bDisplayInvestigateSubMenu)
    {
        ePosition = GetInvestigateReplyLocation(0);
        if (int(ePosition) != 6)
        {
            sConversationOptions[int(ePosition)] = string(m_srTextReturn);
            m_bSlotsUsed[int(ePosition)] = 1;
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
    local Rotator R;
    local float fRadius;
    local BioWorldInfo oBioWorldInfo;
    local BioGamerProfile oBioGamerProfile;
    local BioSubtitles oSubtitles;
    local BioConversation oConversation;
    local ASParams stParam;
    local array<ASParams> lstParams;
    local int nMovieMode;
    local bool bMovieMode;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    oConversation = oBioWorldInfo.m_oCurrentConversation;
    oBioGamerProfile = oBioWorldInfo.GetBioGamerProfile();
    bMovieMode = FALSE;
    if (oBioGamerProfile != None)
    {
        oBioGamerProfile.GetOption(1, nMovieMode);
        bMovieMode = nMovieMode == 1;
    }
    if (oConversation != None && oConversation.NeedToDisplayReplies())
    {
        if (!m_bDisplayingWheel && !bMovieMode)
        {
            UpdateConversationOptions(oConversation);
            m_bDisplayingWheel = TRUE;
        }
        if (!Class'WorldInfo'.static.IsConsoleBuild() && !oPanel.bUsingGamepad)
        {
            stParam.Type = ASParamTypes.ASParam_Integer;
            CalculateArrowPosition(stParam, lstParams);
            lstParams.Length = 0;
        }
        else
        {
            stParam.Type = ASParamTypes.ASParam_Integer;
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
            else
            {
                stParam.nVar = 360;
                lstParams.AddItem(stParam);
                oPanel.InvokeMethodArgs("setArrowPosition", lstParams);
                fLastRadius = 0.0;
            }
        }
        lstParams.Length = 0;
    }
    else if (m_bDisplayingWheel)
    {
        m_bDisplayingWheel = FALSE;
        oPanel.InvokeMethod("HideWheel");
    }
    oSubtitles = oBioWorldInfo.GetSubtitles();
    if (oSubtitles == m_oLastSubtitle && oSubtitles.m_sSubtitle == m_szLastSubtitleText)
    {
        return;
    }
    m_oLastSubtitle = oSubtitles;
    m_szLastSubtitleText = oSubtitles.m_sSubtitle;
    if (oSubtitles.HasSubtitle())
    {
        stParam.Type = ASParamTypes.ASParam_String;
        stParam.sVar = oSubtitles.m_sSubtitle;
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_Integer;
        if (int(oSubtitles.GetRenderMode()) == 3)
        {
            stParam.nVar = 0;
        }
        else if (int(oSubtitles.GetRenderMode()) == 5)
        {
            stParam.nVar = 5;
        }
        else if (MassEffectGuiManager(oPanel.oParentManager).IsInConversation() || oSubtitles.m_bAlert)
        {
            stParam.nVar = 2;
        }
        else
        {
            stParam.nVar = 1;
        }
        lstParams.AddItem(stParam);
        stParam.nVar = (int(oSubtitles.m_FontColor.R) << 16 | int(oSubtitles.m_FontColor.G) << 8) | int(oSubtitles.m_FontColor.B);
        lstParams.AddItem(stParam);
        stParam.nVar = int(oSubtitles.m_FontColor.A);
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_Boolean;
        stParam.bVar = oSubtitles.m_bAlert;
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = oSubtitles.m_FontSize;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("setSubtitle", lstParams);
    }
    else
    {
        oPanel.InvokeMethod("HideSubtitle");
    }
}
public function CalculateArrowPosition(out ASParams stParam, out array<ASParams> lstParams)
{
    local Vector vMouseAngle;
    local Rotator R;
    
    vMouseInput += vInput / AccumulationDivisor;
    vInput.X = 0.0;
    vInput.Y = 0.0;
    vInput.Z = 0.0;
    if (VSize(vMouseInput) > 1.0)
    {
        vMouseInput = Normal(vMouseInput);
    }
    if (VSize(vMouseInput) < 0.300000012)
    {
        vMouseInput = Normal(vMouseInput) * 0.300000012;
    }
    vMouseAngle = Normal(vMouseInput);
    R = Rotator(vMouseAngle);
    stParam.nVar = int(float(R.Yaw) * 0.00549316406);
    if (stParam.nVar < 0)
    {
        stParam.nVar += 360;
    }
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("setArrowPosition", lstParams);
}
public function OnRemovePanel()
{
    m_bDisplayingWheel = FALSE;
}
public function HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            if (oPanel.bUsingGamepad || Class'WorldInfo'.static.IsConsoleBuild())
            {
                vInput.X = fValue;
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            if (oPanel.bUsingGamepad || Class'WorldInfo'.static.IsConsoleBuild())
            {
                vInput.Y = fValue;
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_Y:
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
        default:
    }
}
public final function SkipConversation()
{
    local BioWorldInfo oBioWorldInfo;
    
    oBioWorldInfo = BioWorldInfo(oWorldInfo);
    if (oBioWorldInfo.m_oCurrentConversation != None)
    {
        if (!oBioWorldInfo.m_oCurrentConversation.SkipNode())
        {
            PlayGuiSound('ConvError');
        }
    }
}
public final function SelectConversationSegment()
{
    oPanel.InvokeMethod("SelectConversationSegment");
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
    vMouseInput = vect(1.0, 0.0, 0.0);
    oPanel.bIgnoreGCOnPanelCleanup = TRUE;
    oPanel.SetInputDisabled(TRUE);
    oPanel.InvokeMethod("HideSubtitle");
    oPanel.InvokeMethod("HideWheel");
}
public final function int GetNumReplies(BioConversation oConversation)
{
    return oConversation.m_lstCurrentReplyIndices.Length;
}

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
    AccumulationDivisor = 100.0
    nHandlerID = 5
    bSetGameMode = FALSE
}