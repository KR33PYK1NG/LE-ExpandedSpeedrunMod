Class ESM_LE3;

// Variables
var GameSettings Settings;

// Functions
public static function SkipConversation(BioPlayerController Player)
{
    local BioWorldInfo World;
    local SFXGUIInteraction GUI;
    local BioSFHandler_Conversation ConvHandler;
    local BioConversationController ConvControl;
    local BioConversation Conv;
    local int i;
    
    if ((Player == None || Player.GameModeManager2 == None) || Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Conversation)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if (World == None || World.GetConversationManager() == None)
    {
        return;
    }
    GUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (GUI == None)
    {
        return;
    }
    ConvHandler = GUI.GetConversationHandler(Player);
    if (ConvHandler == None || ConvHandler.oPanel == None)
    {
        return;
    }
    ConvControl = World.GetConversationManager().GetFullConversation();
    if (ConvControl == None)
    {
        return;
    }
    Conv = ConvControl.m_pConvData;
    if (Conv == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE3'.default.Settings))
    {
        return;
    }
    ConvControl.m_bSkippable = TRUE;
    ConvControl.m_bSkipRequested = TRUE;
    ConvControl.m_bSkipProtectionDisabled = TRUE;
    for (i = 0; i < Conv.m_EntryList.Length; i++)
    {
        Conv.m_EntryList[i].bSkippable = TRUE;
    }
    for (i = 0; i < Conv.m_ReplyList.Length; i++)
    {
        Conv.m_ReplyList[i].bUnskippable = FALSE;
    }
    ConvHandler.oPanel.InvokeMethod("SelectOrSkipConversation");
}
public static function SkipNonConversation(BioPlayerController Player)
{
    local BioWorldInfo World;
    
    if ((Player == None || Player.GameModeManager2 == None) || (Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Cinematic && Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Movie) && Player.GameModeManager2.CurrentMode != EGameModes.GameMode_DreamSequence)
    {
        return;
    }
    if (Player.GameModeManager2.CurrentMode == EGameModes.GameMode_Movie && Class'ESM_API'.default.CurrentTarget.Type != CooldownType.Non_Conversation_Start)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if ((World == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE3'.default.Settings)) || Player.GameModeManager2.CurrentMode == EGameModes.GameMode_DreamSequence && Class'ESM_API'.default.CurrentTarget.Path != "biod_nor_600cat4intro.theworld:persistentlevel.main_sequence.dream03.bioseqact_biotogglecinematicmode_1")
    {
        return;
    }
    World.m_bCinematicSkip = TRUE;
    World.m_bDisableCinematicSkip = FALSE;
    World.TriggerCinematicSkippedEvent();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Settings = {
                SpecialRules = ({
                                 Path = "proear_crashedchopper_v_d.node_data_sequence:bioseqevt_convnode_0", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Conversation_Start)
                                }, 
                                {
                                 Path = "cat003_csec_executorroom_m_d.node_data_sequence:bioseqevt_convnode_61", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "end002_illusive_man_m_d.node_data_sequence:bioseqevt_convnode_108", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "end002_illusive_man_dies_m_d.node_data_sequence:bioseqevt_convnode_13", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Start)
                                }, 
                                {
                                 Path = "biop_", 
                                 Delay = 2.0999999, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_proear_410survivors.theworld:persistentlevel.main_sequence.seq_crashed_chopper_crew.bioseqact_biotogglecinematicmode_3", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_proear_410survivors.theworld:persistentlevel.main_sequence.seq_crashed_chopper_crew.bioseqact_biotogglecinematicmode_4", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_promar_240exteriorwalk.theworld:persistentlevel.main_sequence.airlock_and_helmet.sequencereference_1.ref_playerhelmetcontrol.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_cithub_001procit.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 3.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_nor_110tour.theworld:persistentlevel.main_sequence.dream01.start_stage_2.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_kro002_860threesec.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_nor_204kro002_debrief.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_3", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_cat003_080introcutscene.theworld:persistentlevel.main_sequence.intro_sequence.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_cat003_600elevatortrans.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 7.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_gth002_300chase.theworld:persistentlevel.main_sequence.matinee_chase.posses_turret.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_cat002_100intro.theworld:persistentlevel.main_sequence.shuttle_landing.bioseqact_biotogglecinematicmode_5", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_end001_485shepspeech.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_3", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_end002_300timconflict.theworld:persistentlevel.main_sequence.seq_arms_open.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 2.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_end002_510red.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_end002_520blue.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_end002_530green.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }
                               )
               }
}