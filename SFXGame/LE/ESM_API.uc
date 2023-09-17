Class ESM_API;

// Types
struct GameSettings 
{
    var int TargetThreshold;
    var array<SkipRule> SpecialRules;
};
struct SkipRule 
{
    var string Path;
    var float Delay;
    var CooldownType Type;
};
struct SkipTarget 
{
    var string Path;
    var float Start;
    var CooldownType Type;
};
enum CooldownType
{
    Conversation_Node,
    Conversation_Reply,
    Conversation_Start,
    Non_Conversation_Start,
};

// Variables
var SkipRule DefaultConvNodeRule;
var SkipRule DefaultConvStartRule;
var SkipRule DefaultConvReplyRule;
var SkipRule DefaultNonConvStartRule;
var KeyBind ConvScrollUpBind;
var KeyBind ConvScrollDownBind;
var KeyBind ConvMashBind;
var KeyBind ConvHoldBind;
var KeyBind NonConvScrollUpBind;
var KeyBind NonConvScrollDownBind;
var KeyBind NonConvMashBind;
var KeyBind NonConvHoldBind;
var SkipTarget CurrentTarget;
var int TargetCount;
var int LastConvId;

// Functions
public static function StartTarget(string Path, float Start, CooldownType Type)
{
    if (Path != "")
    {
        Class'ESM_API'.default.CurrentTarget.Path = Locs(Path);
    }
    Class'ESM_API'.default.CurrentTarget.Start = Start;
    Class'ESM_API'.default.CurrentTarget.Type = Type;
    Class'ESM_API'.default.TargetCount++;
}
public static function SetupBindings(SFXGameModeBase GameMode)
{
    local int i;
    
    if (((SFXGameModeConversation(GameMode) == None && SFXGameModeCinematic(GameMode) == None) && SFXGameModeMovie(GameMode) == None) && InStr(PathName(GameMode), "SFXGameModeDreamSequence", , , ) == -1)
    {
        return;
    }
    for (i = 0; i < GameMode.Bindings.Length; i++)
    {
        switch (GameMode.Bindings[i].Name)
        {
            case 'MouseScrollUp':
            case 'MouseScrollDown':
            case 'SpaceBar':
            case 'RightMouseButton':
            case 'Escape':
                GameMode.Bindings.Remove(i--, 1);
            default:
        }
    }
    if (SFXGameModeConversation(GameMode) != None)
    {
        GameMode.Bindings.AddItem(Class'ESM_API'.default.ConvScrollUpBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.ConvScrollDownBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.ConvMashBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.ConvHoldBind);
    }
    else
    {
        GameMode.Bindings.AddItem(Class'ESM_API'.default.NonConvScrollUpBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.NonConvScrollDownBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.NonConvMashBind);
        GameMode.Bindings.AddItem(Class'ESM_API'.default.NonConvHoldBind);
    }
}
public static function bool CanSkip(float TimeSeconds, GameSettings Settings)
{
    local float Start;
    local SkipRule Rule;
    
    if (TimeSeconds < 3.0 && Class'ESM_API'.default.TargetCount < Settings.TargetThreshold)
    {
        return FALSE;
    }
    Start = Class'ESM_API'.default.CurrentTarget.Start;
    Rule = FindApplicableRule(Settings);
    return Rule.Delay != 0.0 && TimeSeconds - Start > Rule.Delay;
}
private static final function SkipRule FindApplicableRule(GameSettings Settings)
{
    local string Path;
    local CooldownType Type;
    local SkipRule Rule;
    local int i;
    
    Path = Class'ESM_API'.default.CurrentTarget.Path;
    Type = Class'ESM_API'.default.CurrentTarget.Type;
    for (i = 0; i < Settings.SpecialRules.Length; i++)
    {
        Rule = Settings.SpecialRules[i];
        if (Path == Rule.Path && int(Type) == int(Rule.Type))
        {
            return Rule;
        }
    }
    switch (Type)
    {
        case CooldownType.Conversation_Node:
            return Class'ESM_API'.default.DefaultConvNodeRule;
        case CooldownType.Conversation_Reply:
            return Class'ESM_API'.default.DefaultConvReplyRule;
        case CooldownType.Conversation_Start:
            return Class'ESM_API'.default.DefaultConvStartRule;
        case CooldownType.Non_Conversation_Start:
            return Class'ESM_API'.default.DefaultNonConvStartRule;
        default:
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultConvNodeRule = {Delay = 0.00999999978, Type = CooldownType.Conversation_Node}
    DefaultConvReplyRule = {Delay = 0.100000001, Type = CooldownType.Conversation_Reply}
    DefaultConvStartRule = {Delay = 0.100000001, Type = CooldownType.Conversation_Start}
    DefaultNonConvStartRule = {Delay = 0.100000001, Type = CooldownType.Non_Conversation_Start}
    ConvScrollUpBind = {Name = 'MouseScrollUp', Command = "SelectResponse | ESM_SkipConversation"}
    ConvScrollDownBind = {Name = 'MouseScrollDown', Command = "SelectResponse | ESM_SkipConversation"}
    ConvMashBind = {Name = 'SpaceBar', Command = "SelectResponse | ESM_SkipConversation"}
    ConvHoldBind = {Name = 'RightMouseButton', Command = "InterruptParagon | Repeat SelectResponse | Repeat ESM_SkipConversation"}
    NonConvScrollUpBind = {Name = 'MouseScrollUp', Command = "ESM_SkipNonConversation"}
    NonConvScrollDownBind = {Name = 'MouseScrollDown', Command = "ESM_SkipNonConversation"}
    NonConvMashBind = {Name = 'SpaceBar', Command = "ESM_SkipNonConversation"}
    NonConvHoldBind = {Name = 'RightMouseButton', Command = "Repeat ESM_SkipNonConversation"}
}