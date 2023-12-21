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
    Writeln('�����������! �� ������� ������ ��� �����.');
    Writeln('�� ������������������ �������� ������ � ��������������.');
    Writeln('������� �� ����. ��������, ��� �����������!');
    Writeln('������� Enter, ����� ��������� ����.');
End;

Procedure DisplayRulesFirstStageAndContinue;
Var
    Input: String;
Begin
    Writeln('���� 1: �� ������ �� ��������� ����� ������������ ����� �� 5 ����, � ����� ���������.');
    Writeln('������������ ������ � ���������� ��� �� �����, �� � �������� ������� (�������������)');
    Writeln('��������:');
    Writeln('�������� �����');
    Writeln('�����');
    Writeln('�����, ��������� �������������');
    Writeln('�����');
    Writeln('����� ������!');
    Writeln('��������� ����������� ��������� ������ � ������ ��������� � ������ (������������ ����');
    Writeln('������������� ����� ���������) ��� �������� �����');
    Writeln('����� ���������� ����� ����� � ��� �� ����������� ���� � ��������� ����� ����');
    Writeln('�������������� �����. ����� ��������� ��������� ���� ������ ������ �������������� ����');
    Writeln('�������� ���������� ����� ������� �� ���� ����� � ��� �� ��� ���, ���� ������������ �� ������');
    Writeln('������ ��� �������������� 8 ��������� �����. �� ��� ���� 1 ��������.');
    Repeat
        Writeln('������ ����������? (Y/N)');
        ReadLn(Input);
    Until (Input = 'Y') Or (Input = 'y') Or (Input = 'N') Or (Input = 'n');
    If (Input = 'N') Or (Input = 'n') Then
        Halt;
End;
