{
  Delphi Hooking Library by Aphex
  http://www.iamaphex.cjb.net/
  unremote@knology.net
}

unit AfxCodeHook;

{$IMAGEBASE $13140000}

interface

uses
  Windows;

function SizeOfCode(Code: Pointer): dword;
function SizeOfProc(Proc: Pointer): dword;

function InjectString(Process: Longword; Text: PChar): PChar;
function InjectMemory(Process: Longword; Memory: Pointer; Len: dword): Pointer;
function InjectThread(Process: dword; Thread: Pointer; Info: Pointer;
  InfoLen: dword; Results: Boolean): THandle;
function InjectLibrary(Process: Longword; ModulePath: string): Boolean; overload;
function InjectLibrary(Process: Longword; Src: Pointer): Boolean; overload;
function InjectExe(Process: Longword; EntryPoint: Pointer): Boolean;
function UninjectLibrary(Process: Longword; ModulePath: string): Boolean;

function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: Boolean; dwCreationFlags: Longword; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; ModulePath: string): Boolean; overload;
function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: Boolean; dwCreationFlags: Longword; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; Src: Pointer): Boolean; overload;

function HookCode(TargetModule, TargetProc: string; NewProc: Pointer;
  var OldProc: Pointer): Boolean;
function UnhookCode(OldProc: Pointer): Boolean;

function DeleteFileEx(FilePath: PChar): Boolean;
function DisableSFC: Boolean;

implementation

type
  TModuleList = array of Cardinal;

  PImageImportDescriptor = ^TImageImportDescriptor;

  TImageImportDescriptor = packed record
    OriginalFirstThunk: Longword;
    TimeDateStamp: Longword;
    ForwarderChain: Longword;
    Name: Longword;
    FirstThunk: Longword;
  end;

  PImageBaseRelocation = ^TImageBaseRelocation;

  TImageBaseRelocation = packed record
    VirtualAddress: Cardinal;
    SizeOfBlock: Cardinal;
  end;

  TDllEntryProc = function(hinstDLL: HMODULE; dwReason: Longword;
    lpvReserved: Pointer): Boolean; stdcall;

  TStringArray = array of string;

  TLibInfo = record
    ImageBase: Pointer;
    ImageSize: Longint;
    DllProc: TDllEntryProc;
    DllProcAddress: Pointer;
    LibsUsed: TStringArray;
  end;

  PLibInfo = ^TLibInfo;
  Ppointer = ^Pointer;

  TSections = array[0..0] of TImageSectionHeader;

const
  IMPORTED_NAME_OFFSET = $00000002;
  IMAGE_ORDINAL_FLAG32 = $80000000;
  IMAGE_ORDINAL_MASK32 = $0000FFFF;

  Opcodes1: array[0..255] of Word =
  (
    (16913), (17124), (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (0), (16913), (17124),
    (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (32768), (16913), (17124),
    (8209), (8420), (33793), (35906), (0), (32768), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (32768), (529), (740),
    (17), (228), (1025), (3138), (0), (32768), (24645),
    (24645), (24645), (24645), (24645), (24645), (24645), (24645), (24645),
    (24645), (24645), (24645), (24645), (24645), (24645), (24645), (69),
    (69), (69), (69), (69), (69), (69), (69), (24645), (24645), (24645), (24645),
    (24645), (24645), (24645), (24645), (0),
    (32768), (228), (16922), (0), (0), (0), (0), (3072), (11492), (1024),
    (9444), (0), (0), (0), (0), (5120),
    (5120), (5120), (5120), (5120), (5120), (5120), (5120), (5120), (5120),
    (5120), (5120), (5120), (5120), (5120), (5120), (1296),
    (3488), (1296), (1440), (529), (740), (41489), (41700), (16913), (17124),
    (8209), (8420), (17123), (8420), (227), (416), (0),
    (57414), (57414), (57414), (57414), (57414), (57414), (57414), (32768),
    (0), (0), (0), (0), (0), (0), (32768), (33025),
    (33090), (769), (834), (0), (0), (0), (0), (1025), (3138), (0), (0), (32768),
    (32768), (0), (0), (25604),
    (25604), (25604), (25604), (25604), (25604), (25604), (25604), (27717),
    (27717), (27717), (27717), (27717), (27717), (27717), (27717), (17680),
    (17824), (2048), (0), (8420), (8420), (17680), (19872), (0), (0), (2048),
    (0), (0), (1024), (0), (0), (16656),
    (16800), (16656), (16800), (33792), (33792), (0), (32768), (8), (8), (8),
    (8), (8), (8), (8), (8), (5120),
    (5120), (5120), (5120), (33793), (33858), (1537), (1602), (7168), (7168),
    (0), (5120), (32775), (32839), (519), (583), (0),
    (0), (0), (0), (0), (0), (8), (8), (0), (0), (0), (0), (0), (0), (16656), (416)
    );

  Opcodes2: array[0..255] of Word =
  (
    (280), (288), (8420), (8420), (65535), (0), (0), (0), (0), (0), (65535),
    (65535), (65535), (272), (0), (1325), (63),
    (575), (63), (575), (63), (63), (63), (575), (272), (65535), (65535),
    (65535), (65535), (65535), (65535), (65535), (16419),
    (16419), (547), (547), (65535), (65535), (65535), (65535), (63), (575),
    (47), (575), (61), (61), (63), (63), (0),
    (32768), (32768), (32768), (0), (0), (65535), (65535), (65535), (65535),
    (65535), (65535), (65535), (65535), (65535), (65535), (8420),
    (8420), (8420), (8420), (8420), (8420), (8420), (8420), (8420), (8420),
    (8420), (8420), (8420), (8420), (8420), (8420), (16935),
    (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (237),
    (237), (237), (237), (237), (237), (237), (237), (237), (237), (237), (237),
    (237), (237), (101), (237), (1261),
    (1192), (1192), (1192), (237), (237), (237), (0), (65535), (65535), (65535),
    (65535), (65535), (65535), (613), (749), (7168),
    (7168), (7168), (7168), (7168), (7168), (7168), (7168), (7168), (7168),
    (7168), (7168), (7168), (7168), (7168), (7168), (16656),
    (16656), (16656), (16656), (16656), (16656), (16656), (16656), (16656),
    (16656), (16656), (16656), (16656), (16656), (16656), (16656), (0),
    (0), (32768), (740), (18404), (17380), (49681), (49892), (0), (0), (0),
    (17124), (18404), (17380), (32), (8420), (49681),
    (49892), (8420), (17124), (8420), (8932), (8532), (8476), (65535), (65535),
    (1440), (17124), (8420), (8420), (8532), (8476), (41489),
    (41700), (1087), (548), (1125), (9388), (1087), (33064), (24581), (24581),
    (24581), (24581), (24581), (24581), (24581), (24581), (65535),
    (237), (237), (237), (237), (237), (749), (8364), (237), (237), (237),
    (237), (237), (237), (237), (237), (237),
    (237), (237), (237), (237), (237), (63), (749), (237), (237), (237), (237),
    (237), (237), (237), (237), (65535),
    (237), (237), (237), (237), (237), (237), (237), (237), (237), (237), (237),
    (237), (237), (237), (0)
    );

  Opcodes3: array[0..9] of array[0..15] of Word =
  (
    ((1296), (65535), (16656), (16656), (33040), (33040), (33040), (33040),
    (1296), (65535), (16656), (16656), (33040), (33040), (33040), (33040)),
    ((3488), (65535), (16800), (16800), (33184), (33184), (33184), (33184),
    (3488), (65535), (16800), (16800), (33184), (33184), (33184), (33184)),
    ((288), (288), (288), (288), (288), (288), (288), (288), (54), (54), (48),
    (48), (54), (54), (54), (54)),
    ((288), (65535), (288), (288), (272), (280), (272), (280), (48), (48), (0),
    (48), (0), (0), (0), (0)),
    ((288), (288), (288), (288), (288), (288), (288), (288), (54), (54), (54),
    (54), (65535), (0), (65535), (65535)),
    ((288), (65535), (288), (288), (65535), (304), (65535), (304), (54), (54),
    (54), (54), (0), (54), (54), (0)),
    ((296), (296), (296), (296), (296), (296), (296), (296), (566), (566), (48),
    (48), (566), (566), (566), (566)),
    ((296), (65535), (296), (296), (272), (65535), (272), (280), (48), (48),
    (48), (48), (48), (48), (65535), (65535)),
    ((280), (280), (280), (280), (280), (280), (280), (280), (566), (566), (48),
    (566), (566), (566), (566), (566)),
    ((280), (65535), (280), (280), (304), (296), (304), (296), (48), (48), (48),
    (48), (0), (54), (54), (65535))
    );

function SaveOldFunction(Proc: Pointer; Old: Pointer): Longword; forward;
function GetProcAddressEx(Process: Longword;
  lpModuleName, lpProcName: PChar): Pointer; forward;
function MapLibrary(Process: Longword; Dest, Src: Pointer): TLibInfo; forward;

function SizeOfCode(Code: Pointer): Longword;
var
  Opcode: Word;
  Modrm: Byte;
  Fixed, AddressOveride: Boolean;
  Last, OperandOveride, Flags, Rm, Size, Extend: Longword;
begin
  try
    Last := Longword(Code);
    if Code <> nil then
      begin
        AddressOveride := False;
        Fixed := False;
        OperandOveride := 4;
        Extend := 0;
        repeat
          Opcode := Byte(Code^);
          Code := Pointer(Longword(Code) + 1);
          if Opcode = $66 then
            begin
              OperandOveride := 2;
            end
          else if Opcode = $67 then
            begin
              AddressOveride := True;
            end
          else
            begin
              if not ((Opcode and $E7) = $26) then
                begin
                  if not (Opcode in [$64..$65]) then
                    begin
                      Fixed := True;
                    end;
                end;
            end;
        until Fixed;
        if Opcode = $0F then
          begin
            Opcode := Byte(Code^);
            Flags := Opcodes2[Opcode];
            Opcode := Opcode + $0F00;
            Code := Pointer(Longword(Code) + 1);
          end
        else
          begin
            Flags := Opcodes1[Opcode];
          end;
        if ((Flags and $0038) <> 0) then
          begin
            Modrm := Byte(Code^);
            Rm := Modrm and $7;
            Code := Pointer(Longword(Code) + 1);
            case (Modrm and $C0) of
              $40: Size := 1;
              $80:
                begin
                  if AddressOveride then
                    begin
                      Size := 2;
                    end
                  else
                    Size := 4;
                end;
              else
                begin
                  Size := 0;
                end;
            end;
            if not (((Modrm and $C0) <> $C0) and AddressOveride) then
              begin
                if (Rm = 4) and ((Modrm and $C0) <> $C0) then
                  begin
                    Rm := Byte(Code^) and $7;
                  end;
                if ((Modrm and $C0 = 0) and (Rm = 5)) then
                  begin
                    Size := 4;
                  end;
                Code := Pointer(Longword(Code) + Size);
              end;
            if ((Flags and $0038) = $0008) then
              begin
                case Opcode of
                  $F6: Extend := 0;
                  $F7: Extend := 1;
                  $D8: Extend := 2;
                  $D9: Extend := 3;
                  $DA: Extend := 4;
                  $DB: Extend := 5;
                  $DC: Extend := 6;
                  $DD: Extend := 7;
                  $DE: Extend := 8;
                  $DF: Extend := 9;
                end;
                if ((Modrm and $C0) <> $C0) then
                  begin
                    Flags := Opcodes3[Extend][(Modrm shr 3) and $7];
                  end
                else
                  begin
                    Flags := Opcodes3[Extend][((Modrm shr 3) and $7) + 8];
                  end;
              end;
          end;
        case (Flags and $0C00) of
          $0400: Code := Pointer(Longword(Code) + 1);
          $0800: Code := Pointer(Longword(Code) + 2);
          $0C00: Code := Pointer(Longword(Code) + OperandOveride);
          else
            begin
              case Opcode of
                $9A, $EA: Code := Pointer(Longword(Code) + OperandOveride + 2);
                $C8: Code := Pointer(Longword(Code) + 3);
                $A0..$A3:
                  begin
                    if AddressOveride then
                      begin
                        Code := Pointer(Longword(Code) + 2);
                      end
                    else
                      begin
                        Code := Pointer(Longword(Code) + 4);
                      end;
                  end;
              end;
            end;
        end;
      end;
    Result := Longword(Code) - Last;
  except
    Result := 0;
  end;
end;

function SizeOfProc(Proc: Pointer): Longword;
var
  Length: Longword;
begin
  Result := 0;
  repeat
    Length := SizeOfCode(Proc);
    Inc(Result, Length);
    if ((Length = 1) and (Byte(Proc^) = $C3)) then
      Break;
    Proc := Pointer(Longword(Proc) + Length);
  until Length = 0;
end;

function InjectString(Process: Longword; Text: PChar): PChar;
var
  BytesWritten: Longword;
begin
  Result := VirtualAllocEx(Process, nil, Length(Text) + 1, MEM_COMMIT or
    MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, Text, Length(Text) + 1, BytesWritten);
end;

function InjectMemory(Process: Longword; Memory: Pointer; Len: Longword): Pointer;
var
  BytesWritten: Longword;
begin
  Result := VirtualAllocEx(Process, nil, Len, MEM_COMMIT or MEM_RESERVE,
    PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, Memory, Len, BytesWritten);
end;

function InjectThread(Process: Longword; Thread: Pointer; Info: Pointer;
  InfoLen: Longword; Results: Boolean): THandle;
var
  pThread, pInfo: Pointer;
  BytesRead, TID: Longword;
begin
  pInfo := InjectMemory(Process, Info, InfoLen);
  pThread := InjectMemory(Process, Thread, SizeOfProc(Thread));
  Result := CreateRemoteThread(Process, nil, 0, pThread, pInfo, 0, TID);
  if Results then
    begin
      WaitForSingleObject(Result, INFINITE);
      //ReadProcessMemory(Process, pInfo, Info, InfoLen, BytesRead);
    end;
end;

function InjectLibrary(Process: Longword; ModulePath: string): Boolean;
type
  TInjectLibraryInfo = record
    pLoadLibrary: Pointer;
    lpModuleName: Pointer;
    pSleep: Pointer;
  end;
var
  InjectLibraryInfo: TInjectLibraryInfo;
  Thread: THandle;

  procedure InjectLibraryThread(lpParameter: Pointer); stdcall;
  var
    InjectLibraryInfo: TInjectLibraryInfo;
  begin
    InjectLibraryInfo := TInjectLibraryInfo(lpParameter^);
    asm
             PUSH    InjectLibraryInfo.lpModuleName
             CALL    InjectLibraryInfo.pLoadLibrary
             @noret:
             MOV     EAX, $FFFFFFFF
             PUSH    EAX
             CALL    InjectLibraryInfo.pSleep
             JMP     @noret
    end;
  end;

begin
  Result := False;
  InjectLibraryInfo.pSleep := GetProcAddress(GetModuleHandle('kernel32'), 'Sleep');
  InjectLibraryInfo.pLoadLibrary :=
    GetProcAddress(GetModuleHandle('kernel32'), 'LoadLibraryA');
  InjectLibraryInfo.lpModuleName := InjectString(Process, PChar(ModulePath));
  Thread := InjectThread(Process, @InjectLibraryThread, @InjectLibraryInfo,
    SizeOf(TInjectLibraryInfo), False);
  if Thread = 0 then
    Exit;
  CloseHandle(Thread);
  Result := True;
end;

function InjectLibrary(Process: Longword; Src: Pointer): Boolean;
type
  TDllLoadInfo = record
    Module: Pointer;
    EntryPoint: Pointer;
  end;
var
  Lib: TLibInfo;
  DllLoadInfo: TDllLoadInfo;
  BytesWritten: Longword;
  ImageNtHeaders: PImageNtHeaders;
  pModule: Pointer;
  Offset: Longword;

  procedure DllEntryPoint(lpParameter: Pointer); stdcall;
  var
    LoadInfo: TDllLoadInfo;
  begin
    LoadInfo := TDllLoadInfo(lpParameter^);
    asm
             XOR     EAX, EAX
             PUSH    EAX
             PUSH    DLL_PROCESS_ATTACH
             PUSH    LoadInfo.Module
             CALL    LoadInfo.EntryPoint
    end;
  end;

begin
  Result := False;
  ImageNtHeaders := Pointer(Int64(Cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  Offset := $10000000;
  repeat
    Inc(Offset, $10000);
    pModule := VirtualAlloc(Pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset),
      ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE,
      PAGE_EXECUTE_READWRITE);
    if pModule <> nil then
      begin
        VirtualFree(pModule, 0, MEM_RELEASE);
        pModule := VirtualAllocEx(Process,
          Pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset),
          ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE,
          PAGE_EXECUTE_READWRITE);
      end;
  until ((pModule <> nil) or (Offset > $30000000));
  Lib := MapLibrary(Process, pModule, Src);
  if Lib.ImageBase = nil then
    Exit;
  DllLoadInfo.Module := Lib.ImageBase;
  DllLoadInfo.EntryPoint := Lib.DllProcAddress;
  WriteProcessMemory(Process, pModule, Lib.ImageBase, Lib.ImageSize, BytesWritten);
  if InjectThread(Process, @DllEntryPoint, @DllLoadInfo, SizeOf(TDllLoadInfo),
    True) <> 0 then
    Result := True;
end;

function InjectExe(Process: Longword; EntryPoint: Pointer): Boolean;
var
  Module, NewModule: Pointer;
  Size, TID: Longword;
begin
  Result := False;
  Module := Pointer(GetModuleHandle(nil));
  Size := PImageOptionalHeader(Pointer(Integer(Module) +
    PImageDosHeader(Module)._lfanew + SizeOf(Longword) + SizeOf(TImageFileHeader))).SizeOfImage;
  VirtualFreeEx(Process, Module, 0, MEM_RELEASE);
  NewModule := InjectMemory(Process, Module, Size);
  if CreateRemoteThread(Process, nil, 0, EntryPoint, NewModule, 0, TID) <> 0 then
    Result := True;
end;

function UninjectLibrary(Process: Longword; ModulePath: string): Boolean;
type
  TUninjectLibraryInfo = record
    pFreeLibrary: Pointer;
    pGetModuleHandle: Pointer;
    lpModuleName: Pointer;
    pExitThread: Pointer;
  end;
var
  UninjectLibraryInfo: TUninjectLibraryInfo;
  Thread: THandle;

  procedure UninjectLibraryThread(lpParameter: Pointer); stdcall;
  var
    UninjectLibraryInfo: TUninjectLibraryInfo;
  begin
    UninjectLibraryInfo := TUninjectLibraryInfo(lpParameter^);
    asm
             @1:
             INC     ECX
             PUSH    UninjectLibraryInfo.lpModuleName
             CALL    UninjectLibraryInfo.pGetModuleHandle
             CMP     EAX, 0
             JE      @2
             PUSH    EAX
             CALL    UninjectLibraryInfo.pFreeLibrary
             JMP     @1
             @2:
             PUSH    EAX
             CALL    UninjectLibraryInfo.pExitThread
    end;
  end;

begin
  Result := False;
  UninjectLibraryInfo.pGetModuleHandle :=
    GetProcAddress(GetModuleHandle('kernel32'), 'GetModuleHandleA');
  UninjectLibraryInfo.pFreeLibrary :=
    GetProcAddress(GetModuleHandle('kernel32'), 'FreeLibrary');
  UninjectLibraryInfo.pExitThread :=
    GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  UninjectLibraryInfo.lpModuleName := InjectString(Process, PChar(ModulePath));
  Thread := InjectThread(Process, @UninjectLibraryThread, @UninjectLibraryInfo,
    SizeOf(TUninjectLibraryInfo), False);
  if Thread = 0 then
    Exit;
  CloseHandle(Thread);
  Result := True;
end;

function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: Boolean; dwCreationFlags: Longword; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; ModulePath: string): Boolean;
begin
  Result := False;
  if not CreateProcess(lpApplicationName, lpCommandLine, lpProcessAttributes,
    lpThreadAttributes, bInheritHandles, dwCreationFlags or CREATE_SUSPENDED,
    lpEnvironment, lpCurrentDirectory, lpStartupInfo, lpProcessInformation) then
    Exit;
  Result := InjectLibrary(lpProcessInformation.hProcess, ModulePath);
  ResumeThread(lpProcessInformation.hThread);
end;

function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: Boolean; dwCreationFlags: Longword; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; Src: Pointer): Boolean;
begin
  Result := False;
  if not CreateProcess(lpApplicationName, lpCommandLine, lpProcessAttributes,
    lpThreadAttributes, bInheritHandles, dwCreationFlags or CREATE_SUSPENDED,
    lpEnvironment, lpCurrentDirectory, lpStartupInfo, lpProcessInformation) then
    Exit;
  Result := InjectLibrary(lpProcessInformation.hProcess, Src);
  ResumeThread(lpProcessInformation.hThread);
end;

function HookCode(TargetModule, TargetProc: string; NewProc: Pointer;
  var OldProc: Pointer): Boolean;
var
  Address: Longword;
  OldProtect: Longword;
  OldFunction: Pointer;
  Proc: Pointer;
  hModule: Longword;
begin
  Result := False;
  try
    hModule := LoadLibrary(PChar(TargetModule));
    Proc := GetProcAddress(hModule, PChar(TargetProc));
    Address := Longword(NewProc) - Longword(Proc) - 5;
    VirtualProtect(Proc, 5, PAGE_EXECUTE_READWRITE, OldProtect);
    GetMem(OldFunction, 255);
    Longword(OldFunction^) := Longword(Proc);
    Byte(Pointer(Longword(OldFunction) + 4)^) :=
      SaveOldFunction(Proc, Pointer(Longword(OldFunction) + 5));
    Byte(Pointer(Proc)^) := $E9;
    Longword(Pointer(Longword(Proc) + 1)^) := Address;
    VirtualProtect(Proc, 5, OldProtect, OldProtect);
    OldProc := Pointer(Longword(OldFunction) + 5);
    FreeLibrary(hModule);
  except
    Exit;
  end;
  Result := True;
end;

function UnhookCode(OldProc: Pointer): Boolean;
var
  OldProtect: Longword;
  Proc: Pointer;
  SaveSize: Longword;
begin
  Result := True;
  try
    Proc := Pointer(Longword(Pointer(Longword(OldProc) - 5)^));
    SaveSize := Byte(Pointer(Longword(OldProc) - 1)^);
    VirtualProtect(Proc, 5, PAGE_EXECUTE_READWRITE, OldProtect);
    CopyMemory(Proc, OldProc, SaveSize);
    VirtualProtect(Proc, 5, OldProtect, OldProtect);
    FreeMem(Pointer(Longword(OldProc) - 5));
  except
    Result := False;
  end;
end;

function DeleteFileEx(FilePath: PChar): Boolean;
type
  TDeleteFileExInfo = record
    pSleep: Pointer;
    lpModuleName: Pointer;
    pDeleteFile: Pointer;
    pExitThread: Pointer;
  end;
var
  DeleteFileExInfo: TDeleteFileExInfo;
  Thread: THandle;
  Process: Longword;
  PID: Longword;

  procedure DeleteFileExThread(lpParameter: Pointer); stdcall;
  var
    DeleteFileExInfo: TDeleteFileExInfo;
  begin
    DeleteFileExInfo := TDeleteFileExInfo(lpParameter^);
    asm
             @1:
             PUSH    1000
             CALL    DeleteFileExInfo.pSleep
             PUSH    DeleteFileExInfo.lpModuleName
             CALL    DeleteFileExInfo.pDeleteFile
             CMP     EAX, 0
             JE      @1
             PUSH    EAX
             CALL    DeleteFileExInfo.pExitThread
    end;
  end;

begin
  Result := False;
  GetWindowThreadProcessID(FindWindow('Shell_TrayWnd', nil), @PID);
  Process := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  DeleteFileExInfo.pSleep := GetProcAddress(GetModuleHandle('kernel32'), 'Sleep');
  DeleteFileExInfo.pDeleteFile :=
    GetProcAddress(GetModuleHandle('kernel32'), 'DeleteFileA');
  DeleteFileExInfo.pExitThread :=
    GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  DeleteFileExInfo.lpModuleName := InjectString(Process, FilePath);
  Thread := InjectThread(Process, @DeleteFileExThread, @DeleteFileExInfo,
    SizeOf(TDeleteFileExInfo), False);
  if Thread = 0 then
    Exit;
  CloseHandle(Thread);
  CloseHandle(Process);
  Result := True;
end;

function DisableSFC: Boolean;
var
  Process, SFC, PID, Thread, ThreadID: Longword;
begin
  Result := False;
  SFC := LoadLibrary('sfc.dll');
  GetWindowThreadProcessID(FindWindow('NDDEAgnt', nil), @PID);
  Process := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  Thread := CreateRemoteThread(Process, nil, 0, GetProcAddress(SFC, PChar(2 and $FFFF)),
    nil, 0, ThreadId);
  if Thread = 0 then
    Exit;
  CloseHandle(Thread);
  CloseHandle(Process);
  FreeLibrary(SFC);
  Result := True;
end;

function SaveOldFunction(Proc: Pointer; Old: Pointer): Longword;
var
  SaveSize, Size: Longword;
  Next: Pointer;
begin
  SaveSize := 0;
  Next := Proc;
  while SaveSize < 5 do
    begin
      Size := SizeOfCode(Next);
      Next := Pointer(Longword(Next) + Size);
      Inc(SaveSize, Size);
    end;
  CopyMemory(Old, Proc, SaveSize);
  Byte(Pointer(Longword(Old) + SaveSize)^) := $E9;
  Longword(Pointer(Longword(Old) + SaveSize + 1)^) :=
    Longword(Next) - Longword(Old) - SaveSize - 5;
  Result := SaveSize;
end;

function GetProcAddressEx(Process: Longword; lpModuleName, lpProcName: PChar): Pointer;
type
  TGetProcAddrExInfo = record
    pExitThread: Pointer;
    pGetProcAddress: Pointer;
    pGetModuleHandle: Pointer;
    lpModuleName: Pointer;
    lpProcName: Pointer;
  end;
var
  GetProcAddrExInfo: TGetProcAddrExInfo;
  ExitCode: Longword;
  Thread: THandle;

  procedure GetProcAddrExThread(lpParameter: Pointer); stdcall;
  var
    GetProcAddrExInfo: TGetProcAddrExInfo;
  begin
    GetProcAddrExInfo := TGetProcAddrExInfo(lpParameter^);
    asm
             PUSH    GetProcAddrExInfo.lpModuleName
             CALL    GetProcAddrExInfo.pGetModuleHandle
             PUSH    GetProcAddrExInfo.lpProcName
             PUSH    EAX
             CALL    GetProcAddrExInfo.pGetProcAddress
             PUSH    EAX
             CALL    GetProcAddrExInfo.pExitThread
    end;
  end;

begin
  Result := nil;
  GetProcAddrExInfo.pGetModuleHandle :=
    GetProcAddress(GetModuleHandle('kernel32'), 'GetModuleHandleA');
  GetProcAddrExInfo.pGetProcAddress :=
    GetProcAddress(GetModuleHandle('kernel32'), 'GetProcAddress');
  GetProcAddrExInfo.pExitThread :=
    GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  GetProcAddrExInfo.lpProcName := InjectString(Process, lpProcName);
  GetProcAddrExInfo.lpModuleName := InjectString(Process, lpModuleName);
  Thread := InjectThread(Process, @GetProcAddrExThread, @GetProcAddrExInfo,
    SizeOf(GetProcAddrExInfo), False);
  if Thread <> 0 then
    begin
      WaitForSingleObject(Thread, INFINITE);
      GetExitCodeThread(Thread, ExitCode);
      Result := Pointer(ExitCode);
    end;
end;

function MapLibrary(Process: Longword; Dest, Src: Pointer): TLibInfo;
var
  ImageBase: Pointer;
  ImageBaseDelta: Integer;
  ImageNtHeaders: PImageNtHeaders;
  PSections: ^TSections;
  SectionLoop: Integer;
  SectionBase: Pointer;
  VirtualSectionSize, RawSectionSize: Cardinal;
  OldProtect: Cardinal;
  NewLibInfo: TLibInfo;

  function StrToInt(S: string): Integer;
  begin
    Val(S, Result, Result);
  end;

  procedure Add(Strings: TStringArray; Text: string);
  begin
    SetLength(Strings, Length(Strings) + 1);
    Strings[Length(Strings) - 1] := Text;
  end;

  function Find(Strings: array of string; Text: string; var Index: Integer): Boolean;
  var
    StringLoop: Integer;
  begin
    Result := False;
    for StringLoop := 0 to Length(Strings) - 1 do
      begin
        if lstrcmpi(PChar(Strings[StringLoop]), PChar(Text)) = 0 then
          begin
            Index := StringLoop;
            Result := True;
          end;
      end;
  end;

  function GetSectionProtection(ImageScn: Cardinal): Cardinal;
  begin
    Result := 0;
    if (ImageScn and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
      begin
        Result := Result or PAGE_NOCACHE;
      end;
    if (ImageScn and IMAGE_SCN_MEM_EXECUTE) <> 0 then
      begin
        if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
          begin
            if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
              begin
                Result := Result or PAGE_EXECUTE_READWRITE;
              end
            else
              begin
                Result := Result or PAGE_EXECUTE_READ;
              end;
          end
        else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
          begin
            Result := Result or PAGE_EXECUTE_WRITECOPY;
          end
        else
          begin
            Result := Result or PAGE_EXECUTE;
          end;
      end
    else if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
      begin
        if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
          begin
            Result := Result or PAGE_READWRITE;
          end
        else
          begin
            Result := Result or PAGE_READONLY;
          end;
      end
    else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_WRITECOPY;
      end
    else
      begin
        Result := Result or PAGE_NOACCESS;
      end;
  end;

  procedure ProcessRelocs(PRelocs: PImageBaseRelocation);
  var
    PReloc: PImageBaseRelocation;
    RelocsSize: Cardinal;
    Reloc: PWord;
    ModCount: Cardinal;
    RelocLoop: Cardinal;
  begin
    PReloc := PRelocs;
    RelocsSize := ImageNtHeaders.OptionalHeader.DataDirectory[
      IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
    while Cardinal(PReloc) - Cardinal(PRelocs) < RelocsSize do
      begin
        ModCount := (PReloc.SizeOfBlock - SizeOf(PReloc^)) div 2;
        Reloc := Pointer(Cardinal(PReloc) + SizeOf(PReloc^));
        for RelocLoop := 0 to ModCount - 1 do
          begin
            if Reloc^ and $F000 <> 0 then
              Inc(plongword(Cardinal(ImageBase) + PReloc.VirtualAddress + (Reloc^ and $0FFF))^,
                ImageBaseDelta);
            Inc(Reloc);
          end;
        PReloc := Pointer(Reloc);
      end;
  end;

  procedure ProcessImports(PImports: PImageImportDescriptor);
  var
    PImport: PImageImportDescriptor;
    Import: plongword;
    PImportedName: PChar;
    ProcAddress: Pointer;
    PLibName: PChar;
    ImportLoop: Integer;

    function IsImportByOrdinal(ImportDescriptor: Longword): Boolean;
    begin
      Result := (ImportDescriptor and IMAGE_ORDINAL_FLAG32) <> 0;
    end;

  begin
    PImport := PImports;
    while PImport.Name <> 0 do
      begin
        PLibName := PChar(Cardinal(PImport.Name) + Cardinal(ImageBase));
        if not Find(NewLibInfo.LibsUsed, PLibName, ImportLoop) then
          begin
            InjectLibrary(Process, string(PLibName));
            Add(NewLibInfo.LibsUsed, PLibName);
          end;
        if PImport.TimeDateStamp = 0 then
          begin
            Import := plongword(pImport.FirstThunk + Cardinal(ImageBase));
          end
        else
          begin
            Import := plongword(pImport.OriginalFirstThunk + Cardinal(ImageBase));
          end;
        while Import^ <> 0 do
          begin
            if IsImportByOrdinal(Import^) then
              begin
                ProcAddress := GetProcAddressEx(Process, PLibName, PChar(Import^ and $FFFF));
              end
            else
              begin
                PImportedName := PChar(Import^ + Cardinal(ImageBase) + IMPORTED_NAME_OFFSET);
                ProcAddress := GetProcAddressEx(Process, PLibName, PImportedName);
              end;
            Ppointer(Import)^ := ProcAddress;
            Inc(Import);
          end;
        Inc(PImport);
      end;
  end;

begin
  ImageNtHeaders := Pointer(Int64(Cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  ImageBase := VirtualAlloc(Dest, ImageNtHeaders.OptionalHeader.SizeOfImage,
    MEM_RESERVE, PAGE_NOACCESS);
  ImageBaseDelta := Cardinal(ImageBase) - ImageNtHeaders.OptionalHeader.ImageBase;
  SectionBase := VirtualAlloc(ImageBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders,
    MEM_COMMIT, PAGE_READWRITE);
  Move(Src^, SectionBase^, ImageNtHeaders.OptionalHeader.SizeOfHeaders);
  VirtualProtect(SectionBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders,
    PAGE_READONLY, OldProtect);
  PSections := Pointer(PChar(@(ImageNtHeaders.OptionalHeader)) +
    ImageNtHeaders.FileHeader.SizeOfOptionalHeader);
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
    begin
      VirtualSectionSize := PSections[SectionLoop].Misc.VirtualSize;
      RawSectionSize := PSections[SectionLoop].SizeOfRawData;
      if VirtualSectionSize < RawSectionSize then
        begin
          VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
          RawSectionSize := VirtualSectionSize xor RawSectionSize;
          VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
        end;
      SectionBase := VirtualAlloc(PSections[SectionLoop].VirtualAddress +
        PChar(ImageBase), VirtualSectionSize, MEM_COMMIT, PAGE_READWRITE);
      FillChar(SectionBase^, VirtualSectionSize, 0);
      Move((PChar(src) + PSections[SectionLoop].pointerToRawData)^,
        SectionBase^, RawSectionSize);
    end;
  NewLibInfo.DllProc := TDllEntryProc(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint +
    Cardinal(ImageBase));
  NewLibInfo.DllProcAddress :=
    Pointer(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + Cardinal(ImageBase));
  NewLibInfo.ImageBase := ImageBase;
  NewLibInfo.ImageSize := ImageNtHeaders.OptionalHeader.SizeOfImage;
  SetLength(NewLibInfo.LibsUsed, 0);
  if ImageNtHeaders.OptionalHeader.DataDirectory[
    IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then
    ProcessRelocs(Pointer(ImageNtHeaders.OptionalHeader.DataDirectory[
      IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress + Cardinal(ImageBase)));
  if ImageNtHeaders.OptionalHeader.DataDirectory[
    IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then
    ProcessImports(Pointer(ImageNtHeaders.OptionalHeader.DataDirectory[
      IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress + Cardinal(ImageBase)));
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
    begin
      VirtualProtect(PSections[SectionLoop].VirtualAddress + PChar(ImageBase),
        PSections[SectionLoop].Misc.VirtualSize, GetSectionProtection(
        PSections[SectionLoop].Characteristics), OldProtect);
    end;
  Result := NewLibInfo;
end;

end.
