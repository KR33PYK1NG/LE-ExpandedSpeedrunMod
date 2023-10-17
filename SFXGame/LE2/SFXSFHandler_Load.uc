Class SFXSFHandler_Load extends SFXSFHandler_Save
    native
    transient
    config(UI);

// Types
enum ELoadGuiMode
{
    LoadGuiMode_Default,
    LoadGuiMode_NGPlus,
    LoadGuiMode_Legacy,
};
struct native SaveGUICareerRecord 
{
    var(SaveGUICareerRecord) string CareerName;
    var(SaveGUICareerRecord) string FirstName;
    var(SaveGUICareerRecord) string ClassName;
    var(SaveGUICareerRecord) SaveTimeStamp CreationDate;
    var(SaveGUICareerRecord) int DeviceID;
    var(SaveGUICareerRecord) bool bActiveCareer;
    var(SaveGUICareerRecord) EOriginType Origin;
    var(SaveGUICareerRecord) ENotorietyType Notoriety;
};
const LoadOption_DeleteCareer = 8;
const LoadOption_SelectCareer = 7;
const LoadOption_InitializeCareers = 6;
const LoadOption_ChangeStorageDevice = 11;
const LoadOption_QuitToMainMenu = 5;
const LoadOption_DeleteGame = 4;
const LoadOption_LoadGame = 3;
const LoadOption_Initialize = 1;

// Variables
var(SFXSFHandler_Load) array<SaveGUICareerRecord> CareerList;
var(SFXSFHandler_Load) transient array<SFXSaveDescriptor> CorruptedSaveGames;
var(SFXSFHandler_Load) transient stringref LoadGameLoseProgressText;
var(SFXSFHandler_Load) transient stringref ConfirmLoadGameText;
var(SFXSFHandler_Load) transient stringref CancelLoadGameText;
var(SFXSFHandler_Load) transient stringref CharNameText;
var(SFXSFHandler_Load) transient stringref DeleteCareerText;
var(SFXSFHandler_Load) transient stringref ConfirmDeleteCareerText;
var(SFXSFHandler_Load) transient stringref CancelDeleteCareerText;
var(SFXSFHandler_Load) transient stringref CorruptSaveWarningText;
var(SFXSFHandler_Load) transient stringref ConfirmDeleteCorruptText;
var(SFXSFHandler_Load) transient stringref CancelDeleteCorruptText;
var(SFXSFHandler_Load) transient int CurrentCareerIndex;
var(SFXSFHandler_Load) transient bool bFromMainMenu;
var(SFXSFHandler_Load) ELoadGuiMode LoadMode;

// Functions
public event function HandleButtonRefresh(bool usingGamepad)
{
    local ASParams Param;
    local array<ASParams> Parameters;
    
    Param.Type = ASParamTypes.ASParam_Boolean;
    Param.bVar = usingGamepad;
    Parameters.AddItem(Param);
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        SetMouseShown(!usingGamepad);
    }
    oPanel.InvokeMethodArgs("_root.loadSave.RefreshButtonHelp", Parameters);
}
public function GameSessionEnded()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.ClearStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
    Super(BioSFHandler).GameSessionEnded();
}
public function OnStorageDeviceChanged()
{
    local MassEffectGuiManager GuiMan;
    
    GuiMan = MassEffectGuiManager(oPanel.oParentManager);
    if (GuiMan != None)
    {
        GuiMan.RemoveNamedMessageBox('LoadMessageBox');
        bWaitingOnMsgBox = FALSE;
    }
    oPanel.InvokeMethod("loadSave.InitializeCharacterSelectionScreen");
}
public event function OnPanelRemoved()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.ClearStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
    Super(BioSFHandler).OnPanelRemoved();
}
public event function OnPanelAdded()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    Super.OnPanelAdded();
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.AddStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        SetMouseShown(!oPanel.bUsingGamepad);
    }
}
public function HandleEvent(byte Command, const out array<string> lstArguments)
{
    local MassEffectGuiManager GuiMan;
    local int SaveIdx;
    
    if (bWaitingOnMsgBox)
    {
        return;
    }
    GuiMan = MassEffectGuiManager(oPanel.oParentManager);
    if (GuiMan == None)
    {
        return;
    }
    switch (Command)
    {
        case 1:
            Initialize();
            break;
        case 3:
            SaveIdx = int(lstArguments[0]);
            LoadGame(SaveIdx, GuiMan);
            break;
        case 4:
            LogInternal("Deleting index:" @ int(lstArguments[0]), );
            SaveIdx = int(lstArguments[0]);
            DeleteGame(SaveIdx, GuiMan);
            break;
        case 7:
            SaveIdx = int(lstArguments[0]);
            LoadCareer(SaveIdx, GuiMan);
            break;
        case 8:
            SaveIdx = int(lstArguments[0]);
            DeleteCareer(SaveIdx, GuiMan);
            break;
        case 6:
            BeginInitializeCareers();
            break;
        case 5:
            if (GuiMode == ESaveGuiMode.SaveGuiMode_GameOver)
            {
                GuiMan.HackReloadMainMenu();
            }
            else
            {
                GuiMan.ShowMainMenu(4);
                GuiMan.RemovePanel(oPanel, TRUE);
            }
            break;
        default:
    }
}
public final function DeleteCareer(int SaveIdx, MassEffectGuiManager GuiMan)
{
    local BioMessageBoxOptionalParams Params;
    
    if (SaveIdx >= 0 && SaveIdx < CareerList.Length)
    {
        Params.srAText = ConfirmDeleteCareerText;
        Params.srBText = CancelDeleteCareerText;
        Params.bNoFade = TRUE;
        GuiMan.QueueNamedMessageBox('LoadMessageBox', 3, DeleteCareerText, Params, Callback_ConfirmDeleteCareer, SaveIdx);
        bWaitingOnMsgBox = TRUE;
    }
}
public final function LoadCareer(int SaveIdx, MassEffectGuiManager GuiMan)
{
    if (SaveIdx >= 0 && SaveIdx < CareerList.Length)
    {
        InitializeLoadList(SaveIdx);
    }
}
public final function DeleteGame(int SaveIdx, MassEffectGuiManager GuiMan)
{
    local BioMessageBoxOptionalParams Params;
    
    if (SaveIdx >= 0 && SaveIdx < SaveList.Length)
    {
        Params.srAText = ConfirmDeleteGameText;
        Params.srBText = CancelDeleteGameText;
        Params.bNoFade = TRUE;
        GuiMan.QueueNamedMessageBox('LoadMessageBox', 3, DeleteGameText, Params, Callback_ConfirmDelete, SaveIdx);
        bWaitingOnMsgBox = TRUE;
    }
}
public final function LoadGame(int SaveIdx, MassEffectGuiManager GuiMan)
{
    local BioMessageBoxOptionalParams Params;
    local BioPlayerController PC;
    local Name StreamingChunkName;
    
    if (SaveIdx >= 0 && SaveIdx < SaveList.Length)
    {
        PC = BioPlayerController(oPanel.oParentManager.GetPlayerController());
        if (PC != None)
        {
            BioWorldInfo(PC.WorldInfo).GetCurrentStreamingChunkName(StreamingChunkName);
        }
        if (GuiMode == ESaveGuiMode.SaveGuiMode_MainMenu || GuiMode == ESaveGuiMode.SaveGuiMode_GameOver)
        {
            Callback_ConfirmLoadGame(TRUE, SaveIdx);
        }
        else
        {
            Params.srAText = ConfirmLoadGameText;
            Params.srBText = CancelLoadGameText;
            Params.bNoFade = TRUE;
            GuiMan.QueueNamedMessageBox('LoadMessageBox', 3, LoadGameLoseProgressText, Params, Callback_ConfirmLoadGame, SaveIdx);
            bWaitingOnMsgBox = TRUE;
        }
    }
}
public function Initialize()
{
    local array<ASParams> Args;
    local bool bStartInCareerSelection;
    local SFXCareerCacheEntry CareerCacheEntry;
    local SFXEngine Engine;
    
    if (LoadMode == ELoadGuiMode.LoadGuiMode_Legacy)
    {
        InitImportManager();
    }
    Args.Length = 7;
    Args[0].nVar = 0;
    Args[0].Type = ASParamTypes.ASParam_Integer;
    Args[1].bVar = LoadMode == ELoadGuiMode.LoadGuiMode_Legacy;
    Args[1].Type = ASParamTypes.ASParam_Boolean;
    Args[2].bVar = LoadMode == ELoadGuiMode.LoadGuiMode_NGPlus;
    Args[2].Type = ASParamTypes.ASParam_Boolean;
    Args[3].nVar = int(GuiMode);
    Args[3].Type = ASParamTypes.ASParam_Integer;
    Args[4].nVar = int(ScreenLayout);
    Args[4].Type = ASParamTypes.ASParam_Integer;
    Engine = GetEngine();
    if (LoadMode == ELoadGuiMode.LoadGuiMode_NGPlus || (Engine != None && LoadMode == ELoadGuiMode.LoadGuiMode_Default) && !Engine.TryGetCachedCareer(Engine.GetCurrentSaveDescriptor().Career, CareerCacheEntry))
    {
        bStartInCareerSelection = TRUE;
    }
    Args[5].bVar = bStartInCareerSelection;
    Args[5].Type = ASParamTypes.ASParam_Boolean;
    oPanel.InvokeMethodArgs("loadSave.SetLoadSave", Args);
    if (!bStartInCareerSelection)
    {
        InitializeLoadList();
    }
}
public event function CheckForCorruptSaves()
{
    local MassEffectGuiManager GuiMan;
    local BioMessageBoxOptionalParams Params;
    
    if (CorruptedSaveGames.Length > 0)
    {
        GuiMan = MassEffectGuiManager(oPanel.oParentManager);
        if (GuiMan == None)
        {
            return;
        }
        Params.srAText = ConfirmDeleteCorruptText;
        Params.srBText = CancelDeleteCorruptText;
        Params.bNoFade = TRUE;
        GuiMan.QueueNamedMessageBox('LoadMessageBox', 3, CorruptSaveWarningText, Params, Callback_ConfirmDeleteCorruptSaves);
        bWaitingOnMsgBox = TRUE;
    }
}
public native function Callback_ConfirmDeleteCorruptSaves(bool bAPressed, int context);

public function ResetGui(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    BeginInitializeLoadList();
}
public function SaveCommandCallback_InitializeCareers(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    BeginInitializeCareers();
}
public function Callback_ConfirmDeleteCareer(bool bAPressed, int CareerIdx)
{
    local SFXEngine Engine;
    local SFXSaveDescriptor SaveDescriptor;
    local MassEffectGuiManager oMngr;
    
    oMngr = MassEffectGuiManager(oPanel.oParentManager);
    if (bAPressed)
    {
        Engine = GetEngine();
        if ((Engine != None && CareerIdx >= 0) && CareerIdx < CareerList.Length)
        {
            oMngr.GetSaveLoadWidget().ShowDeletingMessage(TRUE);
            oPanel.SetInputDisabled(TRUE);
            SaveDescriptor.Career = CareerList[CareerIdx].CareerName;
            Engine.RemoveCachedCareer(CareerList[CareerIdx].CareerName);
            Engine.QueueSaveGameCommand(5, SaveDescriptor, SaveCommandCallback_InitializeCareers);
        }
    }
    bWaitingOnMsgBox = FALSE;
}
private final function LoadGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess)
    {
        Class'ESM_LE2'.static.UpdateHeavyAmmo();
    }
    oPanel.SetInputDisabled(FALSE);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        MassEffectGuiManager(oPanel.oParentManager).GetSaveLoadWidget().HideLoadingMessage();
    }
    if (Args.bSuccess == FALSE)
    {
        BeginInitializeLoadList();
    }
}
public function Callback_ConfirmLoadGame(bool bAPressed, int context)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    if (bAPressed)
    {
        PC = BioPlayerController(oPanel.oParentManager.GetPlayerController());
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                Engine.ME1ImportData = None;
                Engine.ME1ImportBonuses.ImportedME1Level = 0;
                Engine.ME1ImportBonuses.StartingME2Level = 0;
                Engine.ME1ImportBonuses.BonusXP = 0.0;
                Engine.ME1ImportBonuses.BonusCredits = 0.0;
                Engine.ME1ImportBonuses.BonusResources = 0.0;
                Engine.ME1ImportBonuses.BonusParagon = 0.0;
                Engine.ME1ImportBonuses.BonusRenegade = 0.0;
                Engine.ME2ImportSaveGame = None;
                if (LoadMode == ELoadGuiMode.LoadGuiMode_NGPlus)
                {
                    Engine.ImportME2Character(SaveList[context].SaveGame);
                }
                else if (LoadMode == ELoadGuiMode.LoadGuiMode_Legacy)
                {
                    Engine.ImportME1Character(SaveList[context].SaveGame);
                }
                else
                {
                    oPanel.SetInputDisabled(TRUE);
                    if (Class'WorldInfo'.static.IsConsoleBuild())
                    {
                        MassEffectGuiManager(oPanel.oParentManager).GetSaveLoadWidget().ShowLoadingMessage();
                    }
                    Class'ESM_LE2'.default.LoadRequested = TRUE;
                    Engine.QueueSaveGameCommand(1, SaveList[context].SaveDescriptor, LoadGameCallback);
                }
            }
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public function FillCareerListCallback_InitializeLoadList()
{
    if (CareerList.Length > 0)
    {
        BeginInitializeLoadList();
    }
}
public final native function InitImportManager();

public final native function EndInitializeLoadList(SFXSaveGameCommandEventArgs Args);

public final native function BeginInitializeLoadList();

public function InitializeLoadList(optional int CareerIdx = -1)
{
    CurrentCareerIndex = CareerIdx;
    BeginInitializeLoadList();
}
public final native function EndInitializeCareers(SFXSaveGameCommandEventArgs Args);

public final native function BeginInitializeCareers();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoadGameLoseProgressText = $152355
    ConfirmLoadGameText = $147164
    CancelLoadGameText = $147165
    CharNameText = $170915
    DeleteCareerText = $165655
    ConfirmDeleteCareerText = $147164
    CancelDeleteCareerText = $147165
    CorruptSaveWarningText = $344331
    ConfirmDeleteCorruptText = $147164
    CancelDeleteCorruptText = $147165
}