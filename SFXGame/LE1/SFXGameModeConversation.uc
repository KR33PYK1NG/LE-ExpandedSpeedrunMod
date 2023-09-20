Class SFXGameModeConversation extends SFXGameModeBase within BioPlayerController
    config(Input);

// Variables
var(SFXGameModeConversation) export BioCameraBehaviorConversation ConversationCam;
var(SFXGameModeConversation) export SFXCameraTransition_GalaxyMap InstantTransition;

// Functions
public exec function ESM_SkipConversation()
{
    Class'ESM_LE1'.static.SkipConversation(Outer);
}
public function Initialize()
{
    Class'ESM_API'.static.SetupBindings(Self);
    Super.Initialize();
}
public exec function SkipConversation()
{
    local MassEffectGuiManager GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = MassEffectGuiManager(Outer.GetScaleFormManager());
    if (GuiMan != None)
    {
        ConvHandler = BioSFHandler_Conversation(GuiMan.m_oConversationPanel.GetDefaultHandler());
        if (ConvHandler != None)
        {
            ConvHandler.SkipConversation();
        }
    }
}
public exec function SelectResponse()
{
    local MassEffectGuiManager GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = MassEffectGuiManager(Outer.GetScaleFormManager());
    if (GuiMan != None)
    {
        ConvHandler = BioSFHandler_Conversation(GuiMan.m_oConversationPanel.GetDefaultHandler());
        if (ConvHandler != None)
        {
            ConvHandler.SelectConversationSegment();
        }
    }
}
public function SFXCameraMode HACK_GetCameraMode()
{
    return ConversationCam;
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    Transition = InstantTransition;
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return ConversationCam;
}
public function Deactivated()
{
    Super.Deactivated();
    Outer.GameModeManager.Helper_ResetStaticConsoleBindings();
}
public function Activated()
{
    local BioWorldInfo BWI;
    local BioGamerProfile Profile;
    local int StickConfig;
    
    Super.Activated();
    if (BioWorldInfo(Outer.WorldInfo) != None)
    {
        BWI = BioWorldInfo(Outer.WorldInfo);
        Profile = BWI != None ? BWI.GetBioGamerProfile() : None;
        if (Profile != None)
        {
            Profile.GetOption(26, StickConfig);
            if (StickConfig == 1)
            {
                Outer.GameModeManager.Helper_SwapStaticConsoleSticks();
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorConversation Name=ConversationCam0
        CameraName = 'ConversationCam'
        bInstantTransition = TRUE
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    ConversationCam = ConversationCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "PC_ConvSelect", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bAllowPlayerRotation = TRUE
    bAllowAIMovement = FALSE
    bAllowHenchmenMovement = FALSE
    Priority = EGameModePriority.ModePriority_Conversation
}