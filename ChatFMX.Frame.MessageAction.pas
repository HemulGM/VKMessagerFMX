﻿unit ChatFMX.Frame.MessageAction;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, VK.Entity.Message, VK.API,
  VK.Entity.Conversation, VK.Entity.Common.ExtendedList, ChatFMX.Frame.Chat,
  ChatFMX.Classes, ChatFMX.Frame.Message.Base;

type
  TFrameMessageAction = class(TFrameMessageBase)
    LabelText: TLabel;
    procedure LabelTextResize(Sender: TObject);
  private
    FText: string;
    FFromText, FMemberText: string;
    procedure SetText(const Value: string);
  public
    procedure Fill(Item: TVkMessage; Data: TVkEntityExtendedList<TVkMessage>; ChatInfo: TChatInfo);
    property Text: string read FText write SetText;
  end;

implementation

uses
  VK.Types, VK.Entity.Group, ChatFMX.Utils, VK.Entity.Profile;

{$R *.fmx}

procedure TFrameMessageAction.Fill(Item: TVkMessage; Data: TVkEntityExtendedList<TVkMessage>; ChatInfo: TChatInfo);
begin
  MessageId := Item.Id;
  TagFloat := MessageId;
  FFromText := 'Кто-то';
  FMemberText := '';
  var P2P := ChatInfo.IsP2P;

  if PeerIdIsUser(Item.FromId) then
  begin
    var User: TVkProfile;
    if Data.GetProfileById(Abs(Item.FromId), User) then
      if P2P then
        FFromText := User.FirstName
      else
        FFromText := User.FullName;
  end
  else
  begin
    var Group: TVkGroup;
    if Data.GetGroupById(Abs(Item.FromId), Group) then
      FFromText := Group.Name;
  end;

  if PeerIdIsUser(Item.Action.MemberId) then
  begin
    var User: TVkProfile;
    if Data.GetProfileById(Abs(Item.Action.MemberId), User) then
      if P2P then
        if User.FirstNameAcc.IsEmpty then
          FMemberText := User.FirstName
        else
          FMemberText := User.FirstNameAcc
      else if User.FirstNameAcc.IsEmpty then
        FMemberText := User.FullName
      else
        FMemberText := User.FullNameAcc;
  end
  else
  begin
    var Group: TVkGroup;
    if Data.GetGroupById(Abs(Item.Action.MemberId), Group) then
      FMemberText := Group.Name;
  end;
  Text := MessageActionToText(Item.Action, Item.FromId, FFromText, FMemberText);

  if Text.IsEmpty then
    Text := Item.Action.Text;
end;

procedure TFrameMessageAction.LabelTextResize(Sender: TObject);
begin
  Height := LabelText.Height + Padding.Top + Padding.Bottom;
end;

procedure TFrameMessageAction.SetText(const Value: string);
begin
  FText := Value;
  LabelText.Text := FText;
  LabelText.AutoSize := False;
  LabelText.AutoSize := True;
end;

end.

