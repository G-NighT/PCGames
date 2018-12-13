{Предметная область: Компьютерные игры.

Сильная сущность - Разработчик:
+ ID_Dev (Код фирмы);
+ Dev_Name (Название фирмы);
+ Off_Site (Оффициальный сайт);
+ Indie (Некомерческий разработчик);
+ Numb_Emp (Число сотрудников).

Слабая сущность - Игры:
+ ID_Game (Код игры);
+ ID_Dev (Код фирмы);
+ Game_Name (Название игры);
+ Publish_Year (Год издания);
+ Rating (Рейтинг игры).}

program PCGames;

uses crt;

type
  tDeveloper = record
    ID_Dev: Integer;
    Dev_Name: String[25];
    Off_Site: String[25];
    Indie: String[1];
    Numb_Emp: Integer;
  end;
  
  tGame = record
    ID_Game: Integer;
    ID_Dev: Integer;
    Game_Name: String[25];
    Publish_Year: Integer;
    Rating: Real;
  end;
  
const
  sDevFileName  = 'Developer.txt';
  sGameFileName  = 'Game.txt';
  
var
  fDev: File of tDeveloper; 
  fGame: File of tGame;
  iCod: Integer;
  //S: SearchRec;

//================ Процедурный блок программы ==================================

function GetLenStr(s: string; len: integer): string;                            // Функция для получения строки необходимой длины
begin
  Result := Copy(s, 1, len);
  while Length(Result) < len do                                                 // Наращиваем длину строки
  Result := Result + ' ';
end;

//------------------------------------------------------------------------------

procedure DisplayDevelopers;                                                    // Процедура вывода на экран всех фирм-разработчиков
var
  Dev: tDeveloper;
begin
  WriteLn;
  WriteLn('     _________________________________________________________________');
  WriteLn('    /    |                        |                      |      |     \');
  WriteLn('   | Код |     Название фирмы     |         Сайт         | Инди | Штат |');
  WriteLn('   +-----+------------------------+----------------------+------+------+');

  Seek(fDev, 0);                                                                // Перемещаем указатель на первый элемент файла
  
  while not Eof(fDev) do                                                        // Цикл чтения и вывода на экран данных
  begin
    Read(fDev, Dev);                                                            // Считываем данных из файла                                               
    WriteLn('   | ' + GetLenStr(IntToStr(Dev.ID_Dev), 3)                        // Выводим данные на экран
            + ' | ' + GetLenStr(Dev.Dev_Name, 22)
            + ' | ' + GetLenStr(Dev.Off_Site, 20)
            + ' | ' + GetLenStr(Dev.Indie, 4)
            + ' | ' + GetLenStr(IntToStr(Dev.Numb_Emp), 4) + ' |');
  end;
  
  WriteLn('   +-----+------------------------+----------------------+------+------+');
  Write('    Нажмите любую кнопку, чтобы вернуться назад');
  Readkey;
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure AddDeveloper;                                                         // Процедура добавления новой фирмы-разработчика
var
  iRecIndex, i, yn: Integer;
  klav: char;
  trigger: boolean;
  idfirm, numbpeople, onemore: string;
  Dev: tDeveloper;
begin
  yn := 1;
  
  while yn = 1 do
    begin
    
      trigger := false;
      idfirm := '';
      numbpeople := '';
      onemore :='';
      
      WriteLn;
      textcolor(14);
      Writeln('Общее число записей в БД: ' + IntToStr(FileSize(fDev)+1));
      textcolor(10);
      Write('Введите индекс записи (0 - начало файла, '                         // Заправшиваем позицию добавляемой записи
            + IntToStr(FileSize(fDev)) + ' - конец файла): ');
      ReadLn(iRecIndex);
      
      if (iRecIndex < 0) or (iRecIndex > FileSize(fDev)) then                   // Проверяем введенный индекс
        begin
          textcolor(12);
          WriteLn('Некорректный индекс!')
        end
      else 
        begin                                                                   // Смещаем текущие записи до конца файла
          if iRecIndex < FileSize(fDev) then
          begin                                                                 // Цикл от конца файла к началу, чтобы данные не перекрывались
            for i := FileSize(fDev) - 1 downto iRecIndex do
            begin
              Seek(fDev, i);                                                    // Перемещаемся на заданную в цикле позицию
              Read(fDev, Dev);                                                  // Считываем предыдущую запись, указатель тем самым переходит на следующую
              Write(fDev, Dev);                                                 // Записываем на это место только что считанную
            end;
          end;
          
          Write('Код фирмы: ');                                                 // Определение индекса
            While trigger = false do
            begin
              klav := ReadKey;
              if not (klav in ['0'..'9']) then
                begin
                  if klav = #13 then
                    trigger := true;
                  klav := #0;
                end
              else
                begin
                  idfirm := idfirm + klav;
                  Dev.ID_Dev := StrToInt(idfirm);
                  Write(klav);
                end;
            end;
          
          WriteLn;
          trigger := false;
          
          Write('Название фирмы: ');                                            // Запрашиваем необходимые данные
          ReadLn(Dev.Dev_Name); 
          
          Write('Адрес сайта: ');
          ReadLn(Dev.Off_Site);
          
          Write('Это некоммерческая фирма? (1/0): ');
          While trigger = false do
            begin
              klav := ReadKey;
              if (klav = #48) or (klav = #49) then
                begin
                  Dev.Indie := klav;
                  WriteLn(klav);
                  trigger := true;
                end
              else
                klav := #0;
            end;
            
          trigger := false;
            
          Write('Число сотрудников: ');
          While trigger = false do
            begin
              klav := ReadKey;
              if not (klav in ['0'..'9']) then
                begin
                  if klav = #13 then
                    trigger := true;
                  klav := #0;
                end
              else
                begin
                  numbpeople := numbpeople + klav;
                  Dev.Numb_Emp := StrToInt(numbpeople);
                  Write(klav);
                end;
            end;
          
          trigger := false;
          
          Seek(fDev, iRecIndex);                                                // Перемещаемся на заданную позицию
          Write(fDev, Dev);                                                     // Записываем данные
        end;
      
      WriteLn();
      WriteLn();
      textcolor(14);
      Write('Добавить ещё одну фирму? (1/0): ');
      While trigger = false do
        begin
          klav := ReadKey;
          if (klav = #48) or (klav = #49) then
            begin
              onemore := onemore + klav;
              WriteLn(onemore);
              yn := StrToInt(onemore);
              trigger := true;
            end
          else
            klav := #0;
        end;
      textcolor(10);
    end;
    
  Delay(1000);
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure EditDeveloper;                                                        // Процедура редактирования фирм
var
  iRecIndex, iFldIndex: Integer;
  Dev: tDeveloper;
begin
  WriteLn;
  
  Write('Введите индекс записи (0 - начало файла, '                             // Заправшиваем позицию изменяемой записи
        + IntToStr(FileSize(fDev) - 1) + ' - конец файла): ');
  ReadLn(iRecIndex);
  Clrscr;
  
  if (iRecIndex < 0) or (iRecIndex >= FileSize(fDev)) then                      // Проверяем введенный индекс
    begin
      textcolor(12);
      WriteLn('Некорректный индекс!')
    end
  else
    begin
      Seek(fDev, iRecIndex);                                                    // Перемещаемся на заданную позицию
      Read(fDev, Dev);                                                          // Считываем запись из файла
      
      WriteLn('   ______________________________');  
      WriteLn('  |  ' + Dev.Dev_Name);
      gotoxy(34,2); Writeln('|');
      Writeln('  |  Какое поле нужно изменить?  |');
      WriteLn('   \____________________________/');
      WriteLn('   |    1 - Код фирмы           |');
      WriteLn('   |    2 - Название фирмы      |');
      WriteLn('   |    3 - Адрес сайта         |');
      WriteLn('   |    4 - Инди фирма          |');
      WriteLn('   |    5 - Число сотрудников   |');
      WriteLn('   +----------------------------+');
      Write('   Ваш выбор: ');
      ReadLn(iFldIndex);
      
      if (iFldIndex > 0) and (iFldIndex < 6) then                               // Проверяем и считываем новые данные
        begin
          case iFldIndex of
            1: begin
                 WriteLn('Старый код фирмы: '+Dev.ID_Dev);
                 Write('Новый код фирмы: ');
                 ReadLn(Dev.ID_Dev);
               end;
            2: begin
                 WriteLn('Старое название фирмы: '+Dev.Dev_Name);
                 Write('Новое название фирмы: ');
                 ReadLn(Dev.Dev_Name);
               end;
            3: begin
                 WriteLn('Старый адрес сайта: '+Dev.Off_Site);
                 Write('Новый адрес сайта: ');
                 ReadLn(Dev.Off_Site);
               end;
            4: begin
                 WriteLn('Старое значение: '+Dev.Indie);
                 Write('Это некоммерческая фирма? (1/0): ');
                 ReadLn(Dev.Indie);
               end;
            5: begin
                 WriteLn('Старый число сотрудников: '+Dev.Numb_Emp);
                 Write('Новое число сотрудников: ');
                 ReadLn(Dev.Numb_Emp);
               end;
          end;
          
          Seek(fDev, iRecIndex);                                                // Перемещаемся на заданную позицию еще раз, т.к. указатель уже перешел дальше
          Write(fDev, Dev);                                                     // Записываем измененные данные
        end
      else 
        begin
          textcolor(12);
          WriteLn('   Некорректный ввод!')
        end;
    end;
  Delay(1000);
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure DeleteGame(Index:Integer);                                            // Процедура удаления игры
var
  i: Integer;
  Game: tGame;
begin
    if Index < FileSize(fGame) - 1 then                                         // Перемещаем все последующие записи на одну запись ближе к началу
    begin
      for i := Index + 1 to FileSize(fGame) - 1 do
      begin
        Seek(fGame, i);                                                         // Переходим на заданную позицию
        Read(fGame, Game);                                                      // Считываем из неё данные
        Seek(fGame, i - 1);                                                     // Переходим на предыдущую позицию
        Write(fGame, Game);                                                     // Записываем туда считанные данные
      end;
    end;
    Seek(fGame, FileSize(fGame) - 1);                                           // Перемещяемся на последнюю позицию в файле
    Truncate(fGame);                                                            // Обрезаем файл
end;

//------------------------------------------------------------------------------

procedure DeleteDeveloper;                                                      // Удаление выбранной записи с последующим уменьшением размеров файла
var
  iRecIndex, i, s1: Integer;
  Dev: tDeveloper;
  Game: tGame;
  tagger: boolean;
begin
  tagger := true;
  WriteLn;
  Write('Введите индекс записи (0 - начало файла, '                             // Зпрравшиваем позицию удаляемой записи }
        + IntToStr(FileSize(fDev) - 1) + ' - конец файла): ');
  ReadLn(iRecIndex);
  
  if (iRecIndex < 0) or (iRecIndex >= FileSize(fDev)) then                      // Проверяем введенный индекс
    begin
      textcolor(12);
      WriteLn('Некорректный индекс!')
    end
  else
    begin
      if iRecIndex < FileSize(fDev) - 1 then                                    // Перемещаем все последующие записи на одну запись ближе к началу
      begin
        for i := iRecIndex + 1 to FileSize(fDev) - 1 do
        begin
          Seek(fDev, i);                                                        // Переходим на заданную позицию
          Read(fDev, Dev);                                                      // Считываем из неё данные
          Seek(fDev, i - 1);                                                    // Переходим на предыдущую позицию
          Write(fDev, Dev);                                                     // Записываем туда считанные данные
        end;
      end;
      Seek(fDev, FileSize(fDev) - 1);                                           // Перемещяемся на последнюю позицию в файле
      Truncate(fDev);                                                           // Обрезаем файл
      
      while tagger = true do                                                    // Далее идёт поиск совпадений ID_Dev по второму файлу
        begin
          s1:=iRecIndex;
          seek(fGame, 0);
          while not eof(fGame) do
            begin
              read(fGame,Game);
              if Game.ID_Dev = s1 then
                begin
                  tagger := true;
                  DeleteGame(Game.ID_Game);
                  write('  Были удалены игры: ');
                  textcolor(14);
                  writeln(Game.Game_Name);
                  textcolor(10);
                end
              else
                begin
                  tagger := false;
                end;
            end;
        end;
    end;
      
  Delay(1000);
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure AddGame;                                                              // Процедура добавления новой игры
var
  iRecIndex, i: Integer;
  Game: tGame;
begin
  WriteLn;
  
  Writeln('Общее число ИГР: ' + IntToStr(FileSize(fGame)+1));
  
  Write('Введите индекс записи (0 - начало файла, '                             // Заправшиваем позицию добавляемой записи
        + IntToStr(FileSize(fGame)) + ' - конец файла): ');
  ReadLn(iRecIndex);
  
  if (iRecIndex < 0) or (iRecIndex > FileSize(fGame)) then                      // Проверяем введенный индекс
    begin
      textcolor(12);
      WriteLn('Некорректный индекс!')
    end
  else 
    begin                                                                       // Смещаем текущие записи до конца файла
      if iRecIndex < FileSize(fGame) then
      begin                                                                     // Цикл от конца файла к началу, чтобы данные не перекрывались
        for i := FileSize(fGame) - 1 downto iRecIndex do
        begin
          Seek(fGame, i);                                                       // Перемещаемся на заданную в цикле позицию
          Read(fGame, Game);                                                    // Считываем предыдущую запись, указатель тем самым переходит на следующую
          Write(fGame, Game);                                                   // Записываем на это место только что считанную
        end;
      end;
      
      Write('Код игры: '); ReadLn(Game.ID_Game);                                // Определение индекса
      Write('Код фирмы: '); ReadLn(Game.ID_Dev);                                // Запрашиваем необходимые данные
      Write('Название игры: '); ReadLn(Game.Game_Name);
      Write('Год издания: '); ReadLn(Game.Publish_Year);
      Write('Рейтинг игры: '); ReadLn(Game.Rating);
      
      Seek(fGame, iRecIndex);                                                   // Перемещаемся на заданную позицию
      Write(fGame, Game);                                                       // Записываем данные
    end;
  Delay(1000);
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure DisplayGames;                                                         // Процедура вывода на экран всех игр
var
  Game: tGame;
begin
  WriteLn;
  WriteLn('     _________________________________________________________________');
  WriteLn('    /    |           |                         |             |        \');
  WriteLn('   | Код | Код фирмы |      Название игры      | Год издания | Рейтинг |');
  WriteLn('   +-----+-----------+-------------------------+-------------+---------+');

  Seek(fGame, 0);                                                               // Перемещаем указатель на первый элемент файла
  
  while not Eof(fGame) do                                                       // Цикл чтения и вывода на экран данных
  begin
    Read(fGame, Game);                                                          // Считываем данных из файла
    WriteLn('   | ' + GetLenStr(IntToStr(Game.ID_Game), 3)                      // Выводим данные на экран
            + ' | ' + GetLenStr(IntToStr(Game.ID_Dev), 9)
            + ' | ' + GetLenStr(Game.Game_Name, 23)
            + ' | ' + GetLenStr(IntToStr(Game.Publish_Year), 11)
            + ' | ' + GetLenStr(FloatToStr(Game.Rating), 7) + ' |');
  end;
  
  WriteLn('   +-----+-----------+-------------------------+-------------+---------+');
  Write('    Нажмите любую кнопку, чтобы вернуться назад');
  Readkey;
  Clrscr;
end;

//------------------------------------------------------------------------------

procedure FindGame;
var
  Game: tGame;
  w,s1,s2: string;
  findtag: boolean;
  kolsims: byte;
begin
  REPEAT
    findtag := false;
    writeln('Для продолжения нажмите любую клавишу, для выхода <Esc>!');
    w := readkey;
    if w = #27 then
      exit;
      begin
        write('Введите часть название игры: ');
        textcolor(14);
        readln(s1);
        textcolor(10);
        kolsims := length(s1);
        seek(fGame, 0);
        while not eof(fGame) do
          begin
            read(fGame,Game);
            s2:=copy(Game.Game_Name,1,kolsims);
	          if s1 = s2 then
	            begin
	              findtag := true;
                textcolor(white);
                writeln;
                writeln('  Код игры: ',Game.ID_Game);
                writeln('  Код разработчика: ',Game.ID_Dev);
                write('  Название игры: ');
                textcolor(14);
                writeln(Game.Game_Name);
                textcolor(white);
                writeln('  Год издания: ',Game.Publish_Year);
                writeln('  Рейтиннг игры: ',Game.Rating);
                writeln;
                textcolor(10);
              end;
          end;
        if findtag = false then
          begin
            textcolor(12);
            writeln;
            writeln('Игра не найдена!');
            writeln;
            textcolor(10);
          end;
      end;
  UNTIL w = #27;
end;

//------------------------------------------------------------------------------

procedure TopDeveloper;
var
  Dev: tDeveloper;
  Game: tGame;
  maxsr, sr, sum: real;
  kolvoelem, i: integer;
  named, w: string;
  masr: array[0..100] of real;
begin
  maxsr := 0;
  seek(fDev, 0);
  while not eof(fDev) do
    begin
      read(fDev,Dev);
      seek(fGame, 0);
      kolvoelem := 0;
      sum := 0;
      sr := 0;
      while not eof(fGame) do
        begin
          read(fGame,Game);
          if Game.ID_Dev = Dev.ID_Dev then
            begin
              kolvoelem := kolvoelem + 1;
              masr[kolvoelem-1] := Game.Rating;
            end;
        end;
      if kolvoelem <> 0 then
        begin
          for i := 0 to kolvoelem-1 do
            begin
              sum := sum + masr[i];
            end;
          sr := sum / kolvoelem;
        end;
      if sr > maxsr then
        begin
          maxsr := sr;
          named := Dev.Dev_Name;
        end;
    end;
    
  Writeln();
  Textcolor(10);
  Write(' Разработчик с наибольшим средним рейтингом (');
  Textcolor(14);
  Write(maxsr);
  Textcolor(10);
  Writeln(')');
  Write(' выпущуенных им игр: ');
  Textcolor(14);
  Writeln(named);
  Writeln;
  Textcolor(12);
  Write(' Нажмите <Esc> для выхода ');
  Textcolor(10);
  w := Readkey;
  if w = #27 then
    Clrscr
  else
    begin
      Clrscr;
      TopDeveloper;
    end;
end;

//------------------------------------------------------------------------------

procedure TopGame;
var
  Game: tGame;
  maxr: real;
  nameg, w: string;
begin
  maxr := 0;
  seek(fGame, 0);
  while not eof(fGame) do
    begin
      read(fGame,Game);
      if Game.Rating > maxr then
        begin
          maxr := Game.Rating;
          nameg := Game.Game_Name;
        end;
    end;
  Writeln();
  Textcolor(10);
  Write(' Наиболее поплярной являяется игра ');
  Textcolor(14);
  Write(nameg);
  Textcolor(10);
  Write(' с рейтингом ');
  Textcolor(14);
  Writeln(maxr);
  Textcolor(10);
  Writeln;
  Textcolor(12);
  Write(' Нажмите <Esc> для выхода ');
  Textcolor(10);
  w := Readkey;
  if w = #27 then
    Clrscr
  else
    begin
      Clrscr;
      TopGame;
    end;
end;

//------------------------------------------------------------------------------

procedure Aegis;                                                                // В каком году больше всего игр и вывести: Название, разработчик, год
var
  Dev: tDeveloper;
  Game: tGame;
  max, count, i, j, ans, one, two: integer;
  w: string;
begin
  max := 0;
  for i := 0 to filesize(fGame)-2 do
    begin
      count := 1;
      seek(fGame, i);
      read(fGame, Game);
      one := Game.Publish_Year;
      for j := i+1 to filesize(fGame)-1 do
        begin
          seek(fGame, j);
          read(fGame, Game);
          two := Game.Publish_Year;
          if one = two then
            inc(count)
        end;
      if count > max then
        begin
          max := count;
          ans := one;
        end;
    end;
  
  Writeln();
  Textcolor(10);
  Write(' Наиболее результативным (выпущено ');
  Textcolor(14);
  Write(max);
  Textcolor(10);
  write(' релизов) явлется год ');
  Textcolor(14);
  Write(ans);
  Textcolor(10);
  Writeln(', а именно:');
  Writeln();
  
  Writeln(' +——————————————————————————————————————————————————————————————————————+');
  Writeln(' |                  Название |   Название разработчика | Год публикации |');
  Writeln(' +——————————————————————————————————————————————————————————————————————+');
  seek(fGame, 0);
  while not eof(fGame) do
    begin
      read(fGame,Game);
      if Game.Publish_Year = ans then
        begin
          seek(fDev, 0);
          while not eof(fDev) do
            begin
              read(fDev,Dev);
              if Dev.ID_Dev = Game.ID_Dev then
                Writeln(' | ',Game.Game_Name:25,' | ',Dev.Dev_Name:23,' | ',Game.Publish_Year:14, ' |');
            end;
        end;
    end;
  Writeln(' +——————————————————————————————————————————————————————————————————————+');
  
  Writeln;
  Textcolor(12);
  Write(' Нажмите <Esc> для выхода ');
  Textcolor(10);
  w := Readkey;
  if w = #27 then
    Clrscr
  else
    begin
      Clrscr;
      Aegis;
    end;
end;

procedure Aegis2;
// из списка фирм вывести все те, у которых в названии есть ХОТЯ БЫ ОДНА цифра в виде: название фирмы, количество игр этой фирмы
var
  Dev: tDeveloper;
  Game: tGame;
  count, i: integer;
  w: string;
  digit_find: boolean;
begin
  Writeln();
  Textcolor(10);
  Write(' Фирмы, в названии которой есть ХОТЯ БЫ ОДНА цифра и количество выпущенных ими игр: ');
  Writeln();
  
  Writeln(' +——————————————————————————————————————————————+');
  Writeln(' |                  Название |   Количество игр |' );
  Writeln(' +——————————————————————————————————————————————+');
  
  seek(fDev, 0);
  while not eof(fDev) do
    begin
      read(fDev,Dev);
      digit_find := false;
      for i := 1 to Length(Dev.Dev_Name) do
        if digit_find = false then
          if Dev.Dev_Name[i] in ['0'..'9'] then
            begin
              digit_find := true;
              count:=0;
              seek(fGame, 0);
              while not eof(fGame) do
                begin
                  read(fGame,Game);
                  if Dev.ID_Dev = Game.ID_Dev then
                    inc(count);
                end;
              Writeln(' | ',Dev.Dev_Name:25,' | ',count:16,' | ');
            end;
    end;
    Writeln(' +——————————————————————————————————————————————+');
    
  w := Readkey;
  if w = #27 then
    Clrscr
  else
    begin
      Clrscr;
      Aegis2;
    end;
end;

//================ Основной блок программы =====================================

begin

  textcolor(15);
  
  Assign(fDev, sDevFileName);                                                   // Связывание переменных с именами файлов
  Assign(fGame, sGameFileName);                                                 
  
  {if FindFirst(fDev, faAnyFile, searchResult) = 1 then                         // Поиск и открытие файлов, в случае, 
    Reset(fDev)                                                                 // если они были обнаружены и создание,
  else                                                                          // если они обнаружены не были.
    Rewrite(fDev);                                                              // К сожалению, PascalABC не работает с
                                                                                // модулем DOS, поэтому эта возможность
  if FindFirst(fGame, faAnyFile, searchResult) = 1 then                         // осталась нереализованной.
    Reset(fGame)
  else
    Rewrite(fGame);}
    
  Reset(fDev);                                                                  // Открытие файлов
  Reset(fGame);

  try                                                                           // Главный цикл
    iCod := 1;
    while (iCod >= 1) and (iCod <= 11) do
      
      begin
        textcolor(14);
        WriteLn('   ______________________________');
        WriteLn('  |                              |');  
        WriteLn('  | ██   ██ █████ ██  ██ ██  ██  |');
        WriteLn('  | ███ ███ ██    ██  ██ ██ █  █ |');
        WriteLn('  | ██ █ ██ ████  ██████ ████  █ |');
        WriteLn('  | ██   ██ ██    ██  ██ ██ █  █ |');
        WriteLn('  | ██   ██ █████ ██  ██ ██  ██  |'); 
        WriteLn('   \____________________________/');
        textcolor(15);
        WriteLn('   |                            |');
        WriteLn('   |    1 - Все разработчики    |');
        WriteLn('   |    2 - Новая фирма         |');
        WriteLn('   |    3 - Внести изменения    |');
        WriteLn('   |    4 - Закрыть фирму       |');
        WriteLn('   |    5 - Релиз новой игры    |');
        WriteLn('   |    6 - Показать все игры   |');
        WriteLn('   |    7 - Поиск игры          |');
        WriteLn('   |    8 - Топ разработчик     |');
        WriteLn('   |    9 - Топ игра            |');
        WriteLn('   |   10 - Результативный год  |');
        WriteLn('   |   11 - Число в имени фирмы |');
        WriteLn('   +----------------------------+');
        WriteLn('   |    0 - Закрыть БД          |');
        WriteLn('   +----------------------------+');
        WriteLn;
        Write('   Выберите режим: ');
        textcolor(10);
        
        ReadLn(iCod);                                                           // Определение действия с БД 
        clrscr;
        
        case iCod of                                                            // Вызор соответствующих процедур
          1: DisplayDevelopers;
          2: AddDeveloper;
          3: EditDeveloper;
          4: DeleteDeveloper;
          5: AddGame;
          6: DisplayGames;
          7: Begin FindGame; Clrscr; end;
          8: TopDeveloper;
          9: TopGame;
          10: Aegis;
          11: Aegis2;
        end;
      end;
      
  finally                                                                       // В конце работы закрываем файлы
    Close(fDev);
    Close(fGame);
  end;
  
end.