roundsPassed := 0;
    correctAnswers := 0;
    DisplayRulesFirstStageAndContinue;
    ClearScreen;
    // Главный цикл программы
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileNames[roundsPassed]);
        while correctAnswers < 3 do
        begin
            Writeln('Исходное слово: ');
            RandomWord := GetRandomWord(Words);
            Writeln(RandomWord);
            Sleep(5000); // Задержка в 5 секунд
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
