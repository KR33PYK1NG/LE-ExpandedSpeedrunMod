Class ESM_LE2;

// Variables
var GameSettings Settings;
var string HWWeaponClass;
var int HWAmmoUsedCount;
var bool LoadRequested;

// Functions
public static function UpdateHeavyAmmo()
{
    local SFXEngine E;
    local array<WeaponSaveRecord> W;
    
    E = Class'SFXEngine'.static.GetEngine();
    W = E.CurrentSaveGame.PlayerRecord.Weapons;
    Class'ESM_LE2'.default.HWWeaponClass = "None";
    Class'ESM_LE2'.default.HWAmmoUsedCount = 0;
    if (W.Length == 0)
    {
        return;
    }
    if (E.GetCurrentSaveDescriptor().Type == ESFXSaveGameType.SaveGameType_Auto)
    {
        if (InStr(string(W[W.Length - 1].WeaponClassName), "ESM_", , , ) != 0)
        {
            return;
        }
        Class'ESM_LE2'.default.HWWeaponClass = Right(string(W[W.Length - 1].WeaponClassName), Len(string(W[W.Length - 1].WeaponClassName)) - 4);
        Class'ESM_LE2'.default.HWAmmoUsedCount = W[W.Length - 1].AmmoUsedCount;
    }
    else
    {
        if (InStr(string(W[W.Length - 1].WeaponClassName), "SFXHeavyWeapon_", , , ) != 0)
        {
            return;
        }
        Class'ESM_LE2'.default.HWWeaponClass = string(W[W.Length - 1].WeaponClassName);
        Class'ESM_LE2'.default.HWAmmoUsedCount = W[W.Length - 1].AmmoUsedCount;
    }
}
public static function SkipConversation(BioPlayerController Player)
{
    local BioWorldInfo World;
    local BioConversation Conv;
    local int I;
    
    if ((Player == None || Player.GameModeManager2 == None) || Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Conversation)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if (World == None)
    {
        return;
    }
    Conv = World.m_oCurrentConversation;
    if (Conv == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE2'.default.Settings))
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
    
    if ((Player == None || Player.GameModeManager2 == None) || Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Cinematic && Player.GameModeManager2.CurrentMode != EGameModes.GameMode_Movie)
    {
        return;
    }
    if (Player.GameModeManager2.CurrentMode == EGameModes.GameMode_Movie && Class'ESM_API'.default.CurrentTarget.Type != CooldownType.Non_Conversation_Start)
    {
        return;
    }
    World = BioWorldInfo(Player.WorldInfo);
    if (World == None || !Class'ESM_API'.static.CanSkip(World.TimeSeconds, Class'ESM_LE2'.default.Settings))
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
                                 Path = "profre_veetor_door_d_d.node_data_sequence:bioseqevt_convnode_107", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "profre_veetor_door_d_d.node_data_sequence:bioseqevt_convnode_111", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "omggra_garrus_intro_d_d.node_data_sequence:bioseqevt_convnode_91", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "prscva_double_cross_d_d.node_data_sequence:bioseqevt_convnode_0", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Conversation_Reply)
                                }, 
                                {
                                 Path = "jnkkga_tankfinal_d_d.node_data_sequence:bioseqevt_convnode_54", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "norcr3_joker_shuttle_d_d.node_data_sequence:bioseqevt_convnode_8", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "endgm2_reaper_reveal_d_d.node_data_sequence:bioseqevt_convnode_2", 
                                 Delay = 4.0, 
                                 Types = (CooldownType.Conversation_Node)
                                }, 
                                {
                                 Path = "biop_", 
                                 Delay = 2.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_nor_117debriefstart.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_prscva_202jackscell.theworld:persistentlevel.main_sequence.release_jack_from_cryo.jack_escape_cutscene.bioseqact_biotogglecinematicmode_5", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_nor_110debriefleadvixen.theworld:persistentlevel.main_sequence.bioseqact_biotogglecinematicmode_0", 
                                 Delay = 0.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = "biod_nor_103cic.theworld:persistentlevel.main_sequence.galaxymap.handle_crit_mission_launch.bioseqact_biotogglecinematicmode_1", 
                                 Delay = 1.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }, 
                                {
                                 Path = ".theworld:persistentlevel.main_sequence.maintenance_shaft.", 
                                 Delay = 30.0, 
                                 Types = (CooldownType.Non_Conversation_Start)
                                }
                               )
               }
}