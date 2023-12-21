Program Project2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

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

Procedure CongratulateUser;

Begin
    Writeln('Поздравляем! Вы успешно прошли все этапы.');
    Writeln('Вы продемонстрировали отличную память и внимательность.');
    Writeln('Спасибо за игру. Надеемся, вам понравилось!');
    Writeln('Нажмите Enter, чтобы завершить игру.');
End;

Procedure DisplayRulesFirstStageAndContinue;
Var
    Input: String;
Begin
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
    Repeat
        Writeln('Хотите продолжить? (Y/N)');
        ReadLn(Input);
    Until (Input = 'Y') Or (Input = 'y') Or (Input = 'N') Or (Input = 'n');
    If (Input = 'N') Or (Input = 'n') Then
        Halt;
End;
