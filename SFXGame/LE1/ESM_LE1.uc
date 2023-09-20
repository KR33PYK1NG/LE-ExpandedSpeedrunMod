Class ESM_LE1;

// Variables
var GameSettings Settings;

// Functions
public static function SkipConversation(BioPlayerController Player)
{
    local BioWorldInfo World;
    local BioConversation Conv;
    local int I;
    
    if ((Player == None || Player.GameModeManager == None) || Player.GameModeManager.CurrentMode != EGameModes.GameMode_Conversation)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if (World == None)
    {
        return;
    }
    Conv = World.m_oCurrentConversation;
    if (Conv == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE1'.default.Settings))
    {
        return;
    }
    Conv.m_bSkippable = TRUE;
    Conv.m_bSkipRequested = TRUE;
    Conv.m_bSkipProtectionDisabled = TRUE;
    Conv.m_bForceUnskippable = FALSE;
    for (I = 0; I < Conv.m_EntryList.Length; I++)
    {
        Conv.m_EntryList[I].bSkippable = TRUE;
    }
    for (I = 0; I < Conv.m_ReplyList.Length; I++)
    {
        Conv.m_ReplyList[I].bUnskippable = FALSE;
    }
    Conv.SkipNode();
}
public static function SkipNonConversation(BioPlayerController Player)
{
    local BioWorldInfo World;
    
    if ((Player == None || Player.GameModeManager == None) || Player.GameModeManager.CurrentMode != EGameModes.GameMode_Cinematic && Player.GameModeManager.CurrentMode != EGameModes.GameMode_Movie)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if (World == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE1'.default.Settings))
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
                TargetThreshold = 1, 
                SpecialRules = ({Path = "ice60_matriarch_n.node_data_sequence:bioseqevt_convnode_18", Delay = 2.0, Type = CooldownType.Conversation_Node}, 
                                {Path = "entrymenu.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_0", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_pro10_11_dsg.theworld:persistentlevel.main_sequence.cutscenes.bioseqact_biotogglecinematicmode_1", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_pro10_11_dsg.theworld:persistentlevel.main_sequence.combats.finalfightover.bioseqact_biotogglecinematicmode_4", Delay = 2.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_nor10_01_dsg.theworld:persistentlevel.main_sequence.flyincutscene.bioseqact_biotogglecinematicmode_0", Delay = 32.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_sta60_03quarian_dsg.theworld:persistentlevel.main_sequence.quarianambush.bioseqact_biotogglecinematicmode_1", Delay = 1.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_sta70_02captain_dsg.theworld:persistentlevel.main_sequence.sarencouncil.bioseqact_biotogglecinematicmode_3", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_sta70_02captain_dsg.theworld:persistentlevel.main_sequence.playerbecomesspectre.bioseqact_biotogglecinematicmode_2", Delay = 6.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_ice60_12_dsg.theworld:persistentlevel.main_sequence.level_events.play_queen_cutscene.bioseqact_biotogglecinematicmode_1", Delay = 1.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_war50_13_dsg.theworld:persistentlevel.main_sequence.dialogs.claws.bioseqact_biotogglecinematicmode_3", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_jug80_07_dsg.theworld:persistentlevel.main_sequence.plot_ch2virmire_extraction80.jug80_trigger_dlg.bioseqact_biotogglecinematicmode_1", Delay = 2.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_jug80_08_dsg.theworld:persistentlevel.main_sequence.choice_started.bioseqact_biotogglecinematicmode_0", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_nor10_06locker_dsg.theworld:persistentlevel.main_sequence.emptylocker.bioseqact_biotogglecinematicmode_0", Delay = 0.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_end20_02_dsg.theworld:persistentlevel.main_sequence.cutscene_playerteleportsthroughtherelay.bioseqact_biotogglecinematicmode_1", Delay = 2.0, Type = CooldownType.Non_Conversation_Start}, 
                                {Path = "bioa_end20_02_dsg.theworld:persistentlevel.main_sequence.elevator_end20_to_end80.bioseqact_biotogglecinematicmode_0", Delay = 96.0, Type = CooldownType.Non_Conversation_Start}
                               )
               }
}