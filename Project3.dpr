﻿program Project3;

{$APPTYPE CONSOLE}
{$R *.res}

uses
    System.SysUtils,
    Classes,
    Windows;

Type
    TWordsArr = Array Of String;
    TPosArr = Array Of Integer;

Function CheckWordsEquality(Const WordFromData, InputedWord: String): Boolean;
Var
    I, Pos: Integer;
Begin
    Pos := Length(InputedWord) + 1;
    For I := 1 To Length(WordFromData) Do
    Begin
        If Not(WordFromData[I] = InputedWord[Pos - I]) Then
        Begin
            CheckWordsEquality := False;
            Exit();
        End;
    End;
    CheckWordsEquality := True;
End;

// тут вообще ничего не трогать никому руки откушу.
procedure ClearScreen;
var
    stdout: THandle;
    csbi: TConsoleScreenBufferInfo;
    ConsoleSize: DWORD;
    NumWritten: DWORD;
    Origin: TCoord;
begin
    stdout := GetStdHandle(STD_OUTPUT_HANDLE);
    Win32Check(stdout <> INVALID_HANDLE_VALUE);
    Win32Check(GetConsoleScreenBufferInfo(stdout, csbi));
    ConsoleSize := csbi.dwSize.X * csbi.dwSize.Y;
    Origin.X := 0;
    Origin.Y := 0;
    Win32Check(FillConsoleOutputCharacter(stdout, ' ', ConsoleSize, Origin,
      NumWritten));
    Win32Check(FillConsoleOutputAttribute(stdout, csbi.wAttributes, ConsoleSize,
      Origin, NumWritten));
    Win32Check(SetConsoleCursorPosition(stdout, Origin));
end;
// дальше трогайте

Function FindWordPos(Const Arr: TWordsArr; InputedWord: String): Integer;
Var
    I: Integer;
Begin
    for I := Low(Arr) to High(Arr) do
    Begin
        if CompareText(Arr[I], InputedWord) = 0 then
        Begin
            FindWordPos := I;
            Exit();
        End;
    End;
    FindWordPos := -1;
End;

function CheckWordsExistanceInArr(Const Arr, InputedWords: TWordsArr): Boolean;
Var
    I, J, CountArr, CountInputed: Integer;
Begin
    for I := Low(InputedWords) to High(InputedWords) do
    Begin
        CountArr := 0;
        CountInputed := 0;
        for J := Low(Arr) to High(Arr) do
        Begin
            if CompareText(Arr[J], InputedWords[I]) = 0 then
                Inc(CountArr);
            if CompareText(InputedWords[J], InputedWords[I]) = 0 then
                Inc(CountInputed);
        End;
        if CountArr <> CountInputed then
        Begin
            CheckWordsExistanceInArr := False;
            Exit;
        End;
    End;
    CheckWordsExistanceInArr := True;
End;

function CheckWordsOrder(WordsFromData, InputedWords: TWordsArr): Boolean;
var
    I: Integer;
begin
    Result := True;
    if Length(WordsFromData) <> Length(InputedWords) then
    begin
        Result := False;
        Exit;
    end;
    for I := Low(WordsFromData) to High(WordsFromData) do
    begin
        if WordsFromData[I] <> InputedWords[I] then
        begin
            Result := False;
            break;
        end;
    end;
end;

function ReverseString(const S: string): string;
var
    I: Integer;
begin
    SetLength(Result, Length(S));
    for I := 1 to Length(S) do
    begin
        Result[I] := S[Length(S) - I + 1];
    end;
end;

function ReverseWords(Words: TWordsArr): TWordsArr;
var
    I: Integer;
begin
    SetLength(Result, Length(Words));
    for I := Low(Words) to High(Words) do
    begin
        Result[I] := ReverseString(Words[I]);
    end;
end;

function ReverseArr(Arr: TWordsArr): TWordsArr;
var
    I: Integer;
begin
    SetLength(Result, Length(Arr));
    for I := Low(Arr) to High(Arr) do
    begin
        Result[High(Arr) - I] := Arr[I];
    end;
end;

function ReadWordsFromFile(const FileName: string): TStringList;
var
    Reader: TStreamReader;
    S: string;
    Words: TStringList;
begin
    Words := TStringList.Create;
    Reader := TStreamReader.Create(FileName, TEncoding.UTF8);
    try
        while not Reader.EndOfStream do
        begin
            S := Reader.ReadLine;
            Words.Add(S);
        end;
    finally
        Reader.Free;
    end;
    Result := Words;
end;

Function GetRandomWord(Words: TStringList): string;
var
    Index: Integer;
begin
    Index := Random(Words.Count);
    Result := Words[Index];
end;

procedure CongratulateUser;
begin
    Writeln('Поздравляем! Вы успешно прошли все этапы.');
    Writeln('Вы продемонстрировали отличную память и внимательность.');
    Writeln('Спасибо за игру. Надеемся, вам понравилось!');
    Writeln('Нажмите клавишу Enter, чтобы завершить игру.');
end;

procedure DisplayRulesFirstStageAndContinue;
var
    input: string;
begin
    Writeln('Этап 1: На экране на некоторое время отображается слово из 5 букв, а затем пропадает.');
    Writeln('Пользователь вводит с клавиатуры это же слово, но в обратном порядке («перевернутым»)');
    Writeln('Например:');
    Writeln('Исходное слово');
    Writeln('СТОЛБ');
    Writeln('Слово, введенное пользователем');
    Writeln('БЛОТС');
    Writeln('ОТВЕТ ВЕРНЫЙ!');
    Writeln('Программа анализирует введенную строку и выдает сообщение о верном (пользователь ввел');
    Writeln('«перевернутое» слово правильно) или неверном вводе');
    Writeln('Затем появляется новое слово с тем же количеством букв и ожидается новый ввод');
    Writeln('«перевернутого» слова. После правильно введенных трех подряд верных «перевернутых» слов');
    Writeln('начинают выводиться слова длиннее на одну букву и так до тех пор, пока пользователь не введет');
    Writeln('подряд три «перевернутых» 8 буквенных слова. На том этап 1 завершен.');
    repeat
        Writeln('Хотите продолжить? (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    if (input = 'Н') or (input = 'н') then
        Halt;
end;

procedure DisplayRulesSecondStageAndContinue;
var
    input: string;
begin
    Writeln('Этап 2: На экране на некоторое время отображается последовательность из 5 различных слов, а');
    Writeln('затем пропадает. Пользователь вводит с клавиатуры эти же слова в произвольном порядке.');
    Writeln('Программа анализирует введенную строку и выдает сообщение о верном (все слова угаданы а');
    Writeln('порядок их следования друг за другом значения не имеет) или неверном (пользователь вспомнил');
    Writeln('не все слова) вводе.');
    Writeln('Например:');
    Writeln('Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА');
    Writeln('Последовательность пользователя ГОЛОВА ТАБЛИЦА МАКСИМУМ СТОЛБ КРОСС');
    Writeln('ОТВЕТ ВЕРНЫЙ!');
    Writeln('Затем появляется новая последовательность из других 5 слов. После правильно введенных трех');
    Writeln('подряд последовательнотей из 5 слов начинают выводиться последовательности из 6 слов и так');
    Writeln('до тех пор, пока пользователь не введет подряд три правильных последовательности из 8 слов.');
    Writeln('На том этап 2 завершен.');
    repeat
        Writeln('Хотите продолжить? (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    if (input = 'Н') or (input = 'н') then
        Halt;
end;

procedure DisplayRulesThirdStageAndContinue;
var
    input: string;
begin
    Writeln('Этап 3: Аналогичен этапу 2. Введенная пользователем последовательность считается верной,');
    Writeln('если совпали не только слова, но и порядок их следования друг за другом.');
    Writeln('Например:');
    Writeln('Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА');
    Writeln('Последовательность пользователя КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА');
    Writeln('ОТВЕТ ВЕРНЫЙ!');
    repeat
        Writeln('Хотите продолжить? (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    if (input = 'Н') or (input = 'н') then
        Halt;
end;

procedure DisplayRulesFourthStageAndContinue;
var
    input: string;
begin
    Writeln('Этап 4: Аналогичен этапу 2. Только пользователь должен вводить последовательнось «перевернутой»');
    Writeln('Например:');
    Writeln('Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА');
    Writeln('Последовательность пользователя ТАБЛИЦА ГОЛОВА СТОЛБ МАКСИМУМ КРОСС');
    Writeln('ОТВЕТ ВЕРНЫЙ!');
    repeat
        Writeln('Хотите продолжить? (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    if (input = 'Н') or (input = 'н') then
        Halt;
end;

procedure DisplayRulesFifthStageAndContinue;
var
    input: string;
begin
    Writeln('Этап 5: Аналогичен этапу 2. Только пользователь должен вводить каждое слово «перевернутым»');
    Writeln('Например:');
    Writeln('Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА');
    Writeln('Последовательность пользователя БЛОТС ССОРК АЦИЛБАТ АВОЛОГ МУМИСКАМ');
    Writeln('ОТВЕТ ВЕРНЫЙ!');
    repeat
        Writeln('Хотите продолжить? (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    if (input = 'Н') or (input = 'н') then
        Halt;
end;

Function AskRules(): string;
var
    input: string;
begin
    Writeln('Приветствуем вас, в тренажере памяти! ');
    Writeln('Вы знакомы с правилами этапов, или же вы хотите,');
    Writeln('чтобы вас уведомляли о правилах, актуальных на данный этап?');
    repeat
        Writeln('Да, представьте/Нет, благодарю. (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    ClearScreen;
    Result := input;
end;

Function AskReady(): string;
var
    input: string;
begin
    Writeln('Вы готовы начать игру?');
    repeat
        Writeln('Да/Нет. (д/н)');
        ReadLn(input);
    until (input = 'Д') or (input = 'д') or (input = 'Н') or (input = 'н');
    Result := input;
end;

Function ChoiseDifficulty(): char;
var
    input: char;
begin
    Writeln('Пожалуйста, выберете уровень сложности. ');
    Writeln('1. Легкий. 1 Этап - 5 секунд. 2 Этап - 25 секунд. 3 Этап - 30 секунд. 4 Этап - 35 секунд. 5 Этап - 40 секунд. ');
    Writeln('2. Средний. 1 Этап - 4 секунд. 2 Этап - 20 секунд. 3 Этап - 25 секунд. 4 Этап - 30 секунд. 5 Этап - 35 секунд. ');
    Writeln('3. Сложный. 1 Этап - 2 секунд. 2 Этап - 10 секунд. 3 Этап - 15 секунд. 4 Этап - 15 секунд. 5 Этап - 20 секунд. ');
    repeat
        Writeln('Легкий(1), Средний(2), Сложный(3). ');
        ReadLn(input);
    until (input = '1') or (input = '2') or (input = '3');
    ClearScreen;
    Result := input;
end;

function Join(const Separator: string; const Words: array of string): string;
var
    I: Integer;
begin
    Result := '';
    for I := Low(Words) to High(Words) do
    begin
        if I <> Low(Words) then
            Result := Result + Separator;
        Result := Result + Words[I];
    end;
end;

function Split(const Separator, input: string): TWordsArr;
var
    StringList: TStringList;
    I: Integer;
begin
    StringList := TStringList.Create;
    try
        StringList.Delimiter := Separator[1];
        StringList.StrictDelimiter := True;
        StringList.DelimitedText := input;
        SetLength(Result, StringList.Count);
        for I := 0 to StringList.Count - 1 do
            Result[I] := StringList[I];
    finally
        StringList.Free;
    end;
end;

var
    WordsFromData, InputedWords: TWordsArr;
    FileNames: array [0 .. 3] of string;
    FileName: string;
    Words: TStringList;
    RandomWord, temp, input: string;
    I, J, K, correctAnswers, roundsPassed: Integer;
    ExePath: string;
    diff: char;

begin
    // Получить путь к исполняемому файлу
    ExePath := ExtractFilePath(ParamStr(0));

    // Определить пути к файлам
    FileNames[0] := ExePath + 'words-5.txt';
    FileNames[1] := ExePath + 'words-6.txt';
    FileNames[2] := ExePath + 'words-7.txt';
    FileNames[3] := ExePath + 'words-8.txt';
    FileName := ExePath + 'words-all.txt';
    Randomize;
    correctAnswers := 0;

    // stage 1
    { Этап 1: На экране на некоторое время отображается слово из 5 букв, а затем пропадает.
      Пользователь вводит с клавиатуры это же слово, но в обратном порядке («перевернутым»)
      Например:
      Исходное слово
      Слово, введенное пользователем
      ОТВЕТ ВЕРНЫЙ!
      СТОЛБ
      БЛОТС
      Программа
      анализирует введенную строку и выдает сообщение о верном (пользователь ввел
      «перевернутое» слово правильно) или неверном вводе
      Затем появляется новое слово с тем же количеством букв и ожидается новый ввод
      «перевернутого» слова. После правильно введенных трех подряд верных «перевернутых» слов
      начинают выводиться слова длиннее на одну букву и так до тех пор, пока пользователь не введет
      подряд три «перевернутых» 8 буквенных слова. На том этап 1 завершен.
    }
    // можно вводить строку во время таймера!!!!! исправить потому что жесть как не честно атата
    roundsPassed := 0;
    correctAnswers := 0;
    input := AskRules();
    diff := ChoiseDifficulty();
    if (input = 'Д') or (input = 'д') then
    begin
        DisplayRulesFirstStageAndContinue;
        ClearScreen;
    end;
    case diff of
        '1':
            Writeln('На вашем уровене сложности у вас 5 секунд на этот этап');
        '2':
            Writeln('На вашем уровене сложности у вас 4 секунды на этот этап');
        '3':
            Writeln('На вашем уровене сложности у вас 2 секунды на этот этап');
    end;
    // Главный цикл программы
    input := AskReady();
    repeat
        if (input = 'Н') or (input = 'н') then
        begin
            Writeln('ОК, начнем, когда вы будете готовы.');
            input := AskReady();
        end;
    until (input = 'Д') or (input = 'д');
    ClearScreen;
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileNames[roundsPassed]);
        while correctAnswers < 3 do
        begin
            Writeln('Исходное слово: ');
            RandomWord := GetRandomWord(Words);
            Writeln(RandomWord);
            case diff of
                '1':
                    Sleep(5000);
                '2':
                    Sleep(4000);
                '3':
                    Sleep(2000);
            end;

            ClearScreen; // Очистка консоли
            Writeln('Введите это слово в обратном порядке:');
            SetLength(InputedWords, 1);
            ReadLn(InputedWords[0]);
            if (InputedWords[0] = '52') then
            begin
                roundsPassed := 4; // Завершить все этапы
                break;
            end
            else if (Length(RandomWord) = Length(InputedWords[0])) and
              CheckWordsEquality(RandomWord, InputedWords[0]) then
            begin
                Writeln('ОТВЕТ ВЕРНЫЙ!');
                Inc(correctAnswers);
            end
            else
            begin
                Writeln('ОТВЕТ НЕВЕРНЫЙ!');
                correctAnswers := 0;
            end;
        end;
        correctAnswers := 0;
        Inc(roundsPassed);
    end;

    // Сброс для следующего этапа
    correctAnswers := 0;
    { Этап 2: На экране на некоторое время отображается последовательность из 5 различных слов, а
      затем пропадает. Пользователь вводит с клавиатуры эти же слова в произвольном порядке.
      Программа анализирует введенную строку и выдает сообщение о верном (все слова угаданы а
      порядок их следования друг за другом значения не имеет) или неверном (пользователь вспомнил
      не все слова) вводе.
      Например:
      Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА
      Последовательность пользователя ГОЛОВА ТАБЛИЦА МАКСИМУМ СТОЛБ КРОСС
      ОТВЕТ ВЕРНЫЙ!
      Затем появляется новая последовательность из других 5 слов. После правильно введенных трех
      подряд последовательнотей из 5 слов начинают выводиться последовательности из 6 слов и так
      до тех пор, пока пользователь не введет подряд три правильных последовательности из 8 слов.
      На том этап 2 завершен. }
    if (input = 'Д') or (input = 'д') then
    begin
        DisplayRulesSecondStageAndContinue;
        ClearScreen;
    end;
    roundsPassed := 0;
    correctAnswers := 0;
    case diff of
        '1':
            Writeln('На вашем уровене сложности у вас 25 секунд на этот этап');
        '2':
            Writeln('На вашем уровене сложности у вас 20 секунды на этот этап');
        '3':
            Writeln('На вашем уровене сложности у вас 10 секунды на этот этап');
    end;
    // Главный цикл программы
    input := AskReady();
    repeat
        if (input = 'Н') or (input = 'н') then
        begin
            Writeln('ОК, начнем, когда вы будете готовы.');
            input := AskReady();
        end;
    until (input = 'Д') or (input = 'д');
    ClearScreen;
    while correctAnswers < 3 do
    begin
        Writeln('Исходные слова: ');
        SetLength(WordsFromData, roundsPassed + 5);
        for K := Low(WordsFromData) to High(WordsFromData) do
        begin
            WordsFromData[K] := GetRandomWord(Words);
        end;
        Writeln(Join(' ', WordsFromData)); // Вывод слов в одной строке
        case diff of
            '1':
                Sleep(25000);
            '2':
                Sleep(20000);
            '3':
                Sleep(10000);
        end; // Задержка в 5 секунд
        ClearScreen; // Очистка консоли
        Writeln('Введите эти слова в любом порядке:');
        ReadLn(temp);
        InputedWords := Split(' ', temp);
        // Разделение введенной строки на слова
        if (InputedWords[Length(InputedWords) - 1] = '52') then
        begin
            roundsPassed := 4; // Завершить все этапы
            break;
        end;
        if CheckWordsExistanceInArr(WordsFromData, InputedWords) then
        begin
            Writeln('ОТВЕТ ВЕРНЫЙ!');
            Inc(correctAnswers);
        end
        else
        begin
            Writeln('ОТВЕТ НЕВЕРНЫЙ!');
            correctAnswers := 0;
        end;
    end;

    // stage 3
    // ... Структура аналогична Stage 2, но проверяет точное совпадение последовательностей
    { конкретнее
      Этап 3: Аналогичен этапу 2. Введенная пользователем последовательность считается верной,
      если совпали не только слова, но и порядок их следования друг за другом.
      Например:
      Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА
      Последовательность пользователя КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА
      ОТВЕТ ВЕРНЫЙ! }
    // Этап 3
    correctAnswers := 0;
    if (input = 'Д') or (input = 'д') then
    begin
        DisplayRulesThirdStageAndContinue;
        ClearScreen;
    end;

    roundsPassed := 0;
    correctAnswers := 0;
    case diff of
        '1':
            Writeln('На вашем уровене сложности у вас 30 секунд на этот этап');
        '2':
            Writeln('На вашем уровене сложности у вас 25 секунды на этот этап');
        '3':
            Writeln('На вашем уровене сложности у вас 15 секунды на этот этап');
    end;
    // Главный цикл программы
    input := AskReady();
    repeat
        if (input = 'Н') or (input = 'н') then
        begin
            Writeln('ОК, начнем, когда вы будете готовы.');
            input := AskReady();
        end;
    until (input = 'Д') or (input = 'д');
    ClearScreen;
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileName);
        while correctAnswers < 3 do
        begin
            Writeln('Исходные слова: ');
            SetLength(WordsFromData, roundsPassed + 5);
            for K := Low(WordsFromData) to High(WordsFromData) do
            begin
                WordsFromData[K] := GetRandomWord(Words);
            end;
            Writeln(Join(' ', WordsFromData)); // Вывод слов в одной строке
            case diff of
                '1':
                    Sleep(30000);
                '2':
                    Sleep(25000);
                '3':
                    Sleep(15000);
            end; // Задержка
            ClearScreen; // Очистка консоли
            Writeln('Введите эти слова в том же порядке:');
            ReadLn(temp);
            InputedWords := Split(' ', temp);
            // Разделение введенной строки на слова
            if (InputedWords[Length(InputedWords) - 1] = '52') then
            begin
                roundsPassed := 4; // Завершить все этапы
                break;
            end;
            if CheckWordsExistanceInArr(WordsFromData, InputedWords) and
              CheckWordsOrder(WordsFromData, InputedWords) then
            begin
                Writeln('ОТВЕТ ВЕРНЫЙ!');
                Inc(correctAnswers);
            end
            else
            begin
                Writeln('ОТВЕТ НЕВЕРНЫЙ!');
                correctAnswers := 0;
            end;
        end;
        correctAnswers := 0;
        Inc(roundsPassed);
    end;

    // Сброс для следующего этапа
    correctAnswers := 0;

    // stage 4
    // ... Структура аналогична Stage 2, но пользователь вводит слова в обратном порядке.
    { Этап 4: Аналогичен этапу 2. Только пользователь должен вводить каждое слово «перевернутым»
      Например:
      Исходная последовательность КРОСС МАКСИМУМ СТОЛБ ГОЛОВА ТАБЛИЦА
      Последовательность пользователя БЛОТС ССОРК АЦИЛБАТ АВОЛОГ МУМИСКАМ
      ОТВЕТ ВЕРНЫЙ! }
    // Этап 4
    if (input = 'Д') or (input = 'д') then
    begin
        DisplayRulesFourthStageAndContinue;
        ClearScreen;
    end;

    roundsPassed := 0;
    correctAnswers := 0;
    case diff of
        '1':
            Writeln('На вашем уровене сложности у вас 35 секунд на этот этап');
        '2':
            Writeln('На вашем уровене сложности у вас 30 секунды на этот этап');
        '3':
            Writeln('На вашем уровене сложности у вас 15 секунды на этот этап');
    end;
    // Главный цикл программы
    input := AskReady();
    repeat
        if (input = 'Н') or (input = 'н') then
        begin
            Writeln('ОК, начнем, когда вы будете готовы.');
            input := AskReady();
        end;
    until (input = 'Д') or (input = 'д');
    ClearScreen;
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileName);
        while correctAnswers < 3 do
        begin
            Writeln('Исходные слова: ');
            SetLength(WordsFromData, roundsPassed + 5);
            for K := Low(WordsFromData) to High(WordsFromData) do
            begin
                WordsFromData[K] := GetRandomWord(Words);
            end;
            Writeln(Join(' ', WordsFromData)); // Вывод слов в одной строке
            case diff of
                '1':
                    Sleep(35000);
                '2':
                    Sleep(30000);
                '3':
                    Sleep(15000);
            end; // Задержка в 5 секунд
            ClearScreen; // Очистка консоли
            Writeln('Введите эти слова в обратном порядке:');
            ReadLn(temp);
            InputedWords := Split(' ', temp);
            // Разделение введенной строки на слова
            if (InputedWords[Length(InputedWords) - 1] = '52') then
            begin
                roundsPassed := 4; // Завершить все этапы
                break;
            end;
            if CheckWordsExistanceInArr(WordsFromData, ReverseArr(InputedWords))
            then
            begin
                Writeln('ОТВЕТ ВЕРНЫЙ!');
                Inc(correctAnswers);
            end
            else
            begin
                Writeln('ОТВЕТ НЕВЕРНЫЙ!');
                correctAnswers := 0;
            end;
        end;
        correctAnswers := 0;
        Inc(roundsPassed);
    end;

    // Этап 5(4)
    if (input = 'Д') or (input = 'д') then
    begin
        DisplayRulesFifthStageAndContinue;
        ClearScreen;
    end;

    roundsPassed := 0;
    correctAnswers := 0;
    case diff of
        '1':
            Writeln('На вашем уровене сложности у вас 40 секунд на этот этап');
        '2':
            Writeln('На вашем уровене сложности у вас 35 секунды на этот этап');
        '3':
            Writeln('На вашем уровене сложности у вас 20 секунды на этот этап');
    end;
    // Главный цикл программы
    input := AskReady();
    repeat
        if (input = 'Н') or (input = 'н') then
        begin
            Writeln('ОК, начнем, когда вы будете готовы.');
            input := AskReady();
        end;
    until (input = 'Д') or (input = 'д');
    ClearScreen;
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileName);
        for J := 1 to 3 do
        begin
            Writeln('Исходные слова: ');
            SetLength(WordsFromData, roundsPassed + 5);
            for K := Low(WordsFromData) to High(WordsFromData) do
            begin
                WordsFromData[K] := GetRandomWord(Words);
            end;
            Writeln(Join(' ', WordsFromData)); // Вывод слов в одной строке
            case diff of
                '1':
                    Sleep(40000);
                '2':
                    Sleep(35000);
                '3':
                    Sleep(20000);
            end; // Задержка в 5 секунд
            ClearScreen; // Очистка консоли
            Writeln('Введите эти слова в обратном порядке:');
            ReadLn(temp);
            InputedWords := Split(' ', temp);
            // Разделение введенной строки на слова
            if (InputedWords[Length(InputedWords) - 1] = '52') then
            begin
                roundsPassed := 4; // Завершить все этапы
                break;
            end;
            if CheckWordsExistanceInArr(ReverseWords(WordsFromData),
              InputedWords) then
            begin
                Writeln('ОТВЕТ ВЕРНЫЙ!');
                Inc(correctAnswers);
            end
            else
            begin
                Writeln('ОТВЕТ НЕВЕРНЫЙ!');
                correctAnswers := 0;
            end;
        end;
        correctAnswers := 0;
        Inc(roundsPassed);
    end;

    CongratulateUser;
    ReadLn;

End.
