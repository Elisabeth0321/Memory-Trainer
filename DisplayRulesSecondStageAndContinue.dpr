DisplayRulesSecondStageAndContinue;
    ClearScreen;
    roundsPassed := 0;
    correctAnswers := 0;
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
                Writeln(WordsFromData[K]);
            end;
            Sleep(5000); // Задержка в 5 секунд
            ClearScreen; // Очистка консоли
            Writeln('Введите эти слова в любом порядке:');
            SetLength(InputedWords, Length(WordsFromData));
            for K := Low(InputedWords) to High(InputedWords) do
            begin
                ReadLn(InputedWords[K]);
                if (InputedWords[K] = '52') then
                begin
                    roundsPassed := 4; // Завершить все этапы
                    break;
                end
            end;
            if roundsPassed = 4 then
                break;

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
        correctAnswers := 0;
        Inc(roundsPassed);
    end;
    // Сброс для следующего этапа
    correctAnswers := 0;
