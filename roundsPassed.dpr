roundsPassed := 0;
    correctAnswers := 0;
    DisplayRulesFirstStageAndContinue;
    ClearScreen;
    // ������� ���� ���������
    while roundsPassed < 4 do
    begin
        Words := ReadWordsFromFile(FileNames[roundsPassed]);
        while correctAnswers < 3 do
        begin
            Writeln('�������� �����: ');
            RandomWord := GetRandomWord(Words);
            Writeln(RandomWord);
            Sleep(5000); // �������� � 5 ������
            ClearScreen; // ������� �������
            Writeln('������� ��� ����� � �������� �������:');
            SetLength(InputedWords, 1);
            ReadLn(InputedWords[0]);
            if (InputedWords[0] = '52') then
            begin
                roundsPassed := 4; // ��������� ��� �����
                break;
            end
            else if (Length(RandomWord) = Length(InputedWords[0])) and
              CheckWordsEquality(RandomWord, InputedWords[0]) then
            begin
                Writeln('����� ������!');
                Inc(correctAnswers);
            end
            else
            begin
                Writeln('����� ��������!');
                correctAnswers := 0;
            end;
        end;
        correctAnswers := 0;
        Inc(roundsPassed);
    end;
    // ����� ��� ���������� �����
    correctAnswers := 0;
