{-----------------------------------------------------------------------
  LOMTaskLib release 1.0

  Copyright - Use and abuse, but dont remove this header from code, and
              gimme a shoutout if you used it.

  Author: ~LOM~
  Website: www.lommage.co.uk
  Contact: mail@lommage.co.uk

  Updates:
  ~~~~~~~~

  TLOMTask[0.1] :- Enumerate Windows, and child windows, send keys etc.

  8th October -                             
    Added TLOMTask Class

  -----------------------------------------------------------------------
}

unit LOMTask;

interface

uses Windows, LOMLib;

const
  WM_CLOSE = $0010;

type
  TLOMTaskOptions = record
    EnumWindowsThatAreVisible: boolean;
    EnumWindowsThatAreEnabled: boolean;
    EnumWindowsThatAreIconic:  boolean;
  end;

  TLOMTaskChildOptions = record
    TaskOptions: TLOMTaskOptions;
    Recursive:   boolean;
  end;

  TLOMTask = class(TObject)
  public
    TaskOptions:      TLOMTaskOptions;
    TaskChildOptions: TLOMTaskChildOptions;

    constructor Create;
    destructor Destroy;

    procedure GetList;
    procedure GetChildList(Index: integer);

    procedure KillWindow(Index: integer);
    procedure CloseWindow(Index: integer);
    procedure RestoreWindow(Index: integer);

    procedure SendKeysTo(Index: integer; const Text: string);
    procedure SendKeysToChild(Index: integer; const Text: string);
  end;

procedure RestoreWindowID(WinHandleWindow: THandle);
procedure KillWindowID(WinHandleWindow: THandle);
procedure CloseWindowID(WinHandleWindow: THandle);

procedure SendKeysID(const Text: string; Window: THandle);

threadvar
  TaskList:   TStrList;
  TaskListID: TStrList;

  TaskChildList:   TStrList;
  TaskChildListID: TStrList;

implementation

procedure RestoreWindowID(WinHandleWindow: THandle);
begin
  ShowWindow(WinHandleWindow, SW_RESTORE);
end;

procedure KillWindowID(WinHandleWindow: THandle);
begin
  PostMessage(WinHandleWindow, $0002, 0, 0);
end;

procedure CloseWindowID(WinHandleWindow: THandle);
begin
  PostMessage(WinHandleWindow, WM_CLOSE, 0, 0);
end;

{ Callback proc for main task list enumeration }
function TaskProc(WindowHandle: HWND; PtrTaskOptions: Pointer): boolean; stdcall;
var
  Caption:     array [0..256] of char;
  TaskOptions: TLOMTaskOptions;
begin
  TaskOptions := TLOMTaskOptions(PtrTaskOptions^);

  if GetWindowText(WindowHandle, Caption, 256) > 0 then
  begin
    if TaskOptions.EnumWindowsThatAreVisible then
    begin
      if IsWindowVisible(WindowHandle) then
      begin
        TaskList.Add(Caption);
        TaskListID.Add(IntToStr(WindowHandle));
      end;
    end;

    if TaskOptions.EnumWindowsThatAreEnabled then
    begin
      if IsWindowEnabled(WindowHandle) then
      begin
        TaskList.Add(Caption);
        TaskListID.Add(IntToStr(WindowHandle));
      end;
    end;

    if TaskOptions.EnumWindowsThatAreIconic then
    begin
      if IsIconic(WindowHandle) then
      begin
        TaskList.Add(Caption);
        TaskListID.Add(IntToStr(WindowHandle));
      end;
    end;
  end;

  Result := True;
end;

{ Callback proc for child task list enumeration }
function TaskChildProc(WindowHandle: HWND; PtrTaskOptions: Pointer): boolean; stdcall;
var
  Caption: array [0..256] of char;
  TaskChildOptions: TLOMTaskChildOptions;
begin
  TaskChildOptions := TLOMTaskChildOptions(PtrTaskOptions^);

  if GetWindowText(WindowHandle, Caption, 256) > 0 then
  begin
    if TaskChildOptions.TaskOptions.EnumWindowsThatAreVisible then
    begin
      if IsWindowVisible(WindowHandle) then
      begin
        TaskChildList.Add(Caption);
        TaskChildListID.Add(IntToStr(WindowHandle));
      end;
    end;

    if TaskChildOptions.TaskOptions.EnumWindowsThatAreEnabled then
    begin
      if IsWindowEnabled(WindowHandle) then
      begin
        TaskChildList.Add(Caption);
        TaskChildListID.Add(IntToStr(WindowHandle));
      end;
    end;

    if TaskChildOptions.TaskOptions.EnumWindowsThatAreIconic then
    begin
      if IsIconic(WindowHandle) then
      begin
        TaskChildList.Add(Caption);
        TaskChildListID.Add(IntToStr(WindowHandle));
      end;
    end;

    if TaskChildOptions.Recursive then
      if GetWindow(WindowHandle, GW_CHILD) = 0 then
        EnumChildWindows(WindowHandle, @TaskChildProc, 0);
  end;

  Result := True;
end;

constructor TLOMTask.Create;
begin
  TaskList   := TStrList.Create;
  TaskListID := TStrList.Create;

  TaskChildList   := TStrList.Create;
  TaskChildListID := TStrList.Create;

  with TaskOptions do
  begin
    EnumWindowsThatAreVisible := True;
    EnumWindowsThatAreEnabled := False;
    EnumWindowsThatAreIconic  := False;
  end;

  with TaskChildOptions.TaskOptions do
  begin
    EnumWindowsThatAreVisible := True;
    EnumWindowsThatAreEnabled := False;
    EnumWindowsThatAreIconic  := False;
  end;
end;

destructor TLOMTask.Destroy;
begin
  TaskList.Clear;
  TaskListID.Clear;

  TaskChildList.Clear;
  TaskChildListID.Clear;

  TaskList.Free;
  TaskListID.Free;

  TaskChildList.Free;
  TaskChildListID.Free;
end;

procedure TLOMTask.GetList;
begin
  EnumWindows(@TaskProc, integer(@TaskOptions));
end;

procedure TLOMTask.GetChildList(Index: integer);
begin
  EnumChildWindows(StrToInt(TaskListID.Strings[Index]), @TaskChildProc,
    integer(@TaskChildOptions));
end;

procedure TLOMTask.KillWindow(Index: integer);
begin
  KillWindowID(StrToInt(TaskListID.Strings[Index]));
end;

procedure TLOMTask.CloseWindow(Index: integer);
begin
  CloseWindowID(StrToInt(TaskListID.Strings[Index]));
end;

procedure TLOMTask.RestoreWindow(Index: integer);
begin
  RestoreWindowID(StrToInt(TaskListID.Strings[Index]));
end;

{ Code taken from a SendKeys component - cant remember which?!?! }

procedure MakeWindowActive(whandle: hWnd);
begin
  if IsIconic(whandle) then
    ShowWindow(whandle, SW_RESTORE)
  //else BringWindowToTop(whandle);
  else
    setForegroundWindow(whandle);
end;

function GetHandleFromWindowTitle(const TitleText: string): hWnd;
begin
  Result := FindWindow(PChar(0), PChar(TitleText));
end;

procedure SendKeysID(const Text: string; Window: THandle);
var
  i:     integer;
  shift: boolean;
  vk, scancode: word;
  ch:    char;
  c, s:  byte;
const
  vk_keys: array[0..10] of byte =
    (VK_HOME, VK_END, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_PRIOR, VK_NEXT,
    VK_INSERT, VK_DELETE, VK_RETURN);
  vk_shft: array[0..2] of byte = (VK_SHIFT, VK_CONTROL, VK_MENU);
  flags: array[False..True] of integer = (KEYEVENTF_KEYUP, 0);
begin
  shift := False;

  for i := 1 to Length(Text) do
  begin
    ch := Text[i];

    if Ch = '*' then
    begin
      scancode := MapVirtualKey(VK_CONTROL, 0);
      Keybd_Event(VK_CONTROL, scancode, 0, 0);
    end
    else if Ch = '%' then
      //este condicional fue agregado por mi y es para liberar la tecla control
    begin
      scancode := MapVirtualKey(VK_CONTROL, 0);
      Keybd_Event(VK_CONTROL, scancode, KEYEVENTF_KEYUP, 0);
    end
    else

    if Ord(Ch) = 124 then
    begin
      scancode := MapVirtualKey(VK_RETURN, 0);
      Keybd_Event(VK_RETURN, scancode, 0, 0);
    end
    else

    if Ch = '&' then
    begin
      scancode := MapVirtualKey(VK_TAB, 0);
      Keybd_Event(VK_TAB, scancode, 0, 0);
    end
    else

    if ch >= #250 then
    begin
      s     := Ord(ch) - 250;
      shift := not Odd(s);
      c     := vk_shft[s shr 1];
      scancode := MapVirtualKey(c, 0);
      Keybd_Event(c, scancode, flags[shift], 0);
    end
    else
    begin
      vk := 0;
      if ch >= #240 then
        c := vk_keys[Ord(ch) - 240]
      else
      if ch >= #228 then
        c := Ord(ch) - 116
      else
      if ch < #32 then
        c := Ord(ch)
      else
      begin
        vk := VkKeyScan(ch);
        c  := LoByte(vk);
      end;

      scancode := MapVirtualKey(c, 0);

      if not shift and (Hi(vk) > 0) then
        Keybd_Event(VK_SHIFT, $2A, 0, 0);

      Keybd_Event(c, scancode, 0, 0);
      Keybd_Event(c, scancode, KEYEVENTF_KEYUP, 0);

      if not shift and (Hi(vk) > 0) then
        Keybd_Event(VK_SHIFT, $2A, KEYEVENTF_KEYUP, 0);
    end;

    if Ch = '*' then
    begin
      scancode := MapVirtualKey(VK_CONTROL, 0);
      Keybd_Event(VK_CONTROL, scancode, 0, 0);
      //      Keybd_Event(VK_CONTROL, $2A, KEYEVENTF_KEYUP, 0);
    end;

  end;
end;

procedure TLOMTask.SendKeysTo(Index: integer; const Text: string);
begin
  MakeWindowActive(StrToInt(TaskListID.Strings[Index]));
  SendKeysID(Text, StrToInt(TaskListID.Strings[Index]));
end;

procedure TLOMTask.SendKeysToChild(Index: integer; const Text: string);
begin
  MakeWindowActive(StrToInt(TaskChildListID.Strings[Index]));
  SendKeysID(Text, StrToInt(TaskChildListID.Strings[Index]));
end;

end.
