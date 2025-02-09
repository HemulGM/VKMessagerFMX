﻿unit ChatFMX.Frame.Attachment.PinnedMessage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, VK.API, VK.Entity.Message,
  VK.Entity.Conversation, System.Messaging, ChatFMX.Frame.Attachment,
  VK.Entity.Common.ExtendedList;

type
  TFrameAttachmentPinnedMessage = class(TFrameAttachment)
    LayoutContent: TLayout;
    LayoutText: TLayout;
    LabelText: TLabel;
    LayoutFrom: TLayout;
    LabelFrom: TLabel;
    LabelTime: TLabel;
    procedure LabelFromMouseEnter(Sender: TObject);
    procedure LabelFromMouseLeave(Sender: TObject);
  private
    FText: string;
    FIsAttachmentText: Boolean;
    FFrom: string;
    FDate: TDateTime;
    FMessageId: Int64;
    procedure SetText(const Value: string);
    procedure SetIsAttachmentText(const Value: Boolean);
    procedure SetFrom(const Value: string);
    procedure SetDate(const Value: TDateTime);
    procedure SetMessageId(const Value: Int64);
  public
    procedure Fill(Item: TVkMessage; Data: IExtended);
    property Text: string read FText write SetText;
    property From: string read FFrom write SetFrom;
    property Date: TDateTime read FDate write SetDate;
    property IsAttachmentText: Boolean read FIsAttachmentText write SetIsAttachmentText;
    property MessageId: Int64 read FMessageId write SetMessageId;
  end;

implementation

uses
  VK.Types, VK.Entity.Profile, VK.Entity.Group, VK.Entity.Common,
  ChatFMX.PreviewManager, ChatFMX.Utils;

{$R *.fmx}

procedure TFrameAttachmentPinnedMessage.Fill(Item: TVkMessage; Data: IExtended);
begin
  FMessageId := Item.Id;
  Date := Item.Date;
  Text := ParseMention(PrepareForPreview(Item.Text));
  From := '';
  IsAttachmentText := False;
  if PeerIdIsUser(Item.FromId) then
  begin
    var User: TVkProfile;
    if Data.GetProfileById(Item.FromId, User) then
      From := User.FullName;
  end
  else
  begin
    var Group: TVkGroup;
    if Data.GetGroupById(Item.FromId, Group) then
      From := Group.Name;
  end;
  if Text.IsEmpty and (Length(Item.Attachments) > 0) then
  begin
    var Attachment := Item.Attachments[0];
    Text := AttachmentToText(Attachment.&Type);
    IsAttachmentText := True;
  end;
  if Text.IsEmpty and Assigned(Item.Geo) then
  begin
    Text := 'Карта';
    IsAttachmentText := True;
  end;
end;

procedure TFrameAttachmentPinnedMessage.LabelFromMouseEnter(Sender: TObject);
var
  Control: TLabel absolute Sender;
begin
  Control.TextSettings.Font.Style := Control.TextSettings.Font.Style + [TFontStyle.fsUnderline];
end;

procedure TFrameAttachmentPinnedMessage.LabelFromMouseLeave(Sender: TObject);
var
  Control: TLabel absolute Sender;
begin
  Control.TextSettings.Font.Style := Control.TextSettings.Font.Style - [TFontStyle.fsUnderline];
end;

procedure TFrameAttachmentPinnedMessage.SetDate(const Value: TDateTime);
begin
  FDate := Value;
  LabelTime.Text := HumanDateTime(FDate, True, True);
end;

procedure TFrameAttachmentPinnedMessage.SetFrom(const Value: string);
begin
  FFrom := Value;
  LabelFrom.Text := FFrom;
end;

procedure TFrameAttachmentPinnedMessage.SetIsAttachmentText(const Value: Boolean);
begin
  FIsAttachmentText := Value;
  if FIsAttachmentText then
    LabelText.FontColor := $FF71AAEB
  else
    LabelText.FontColor := $FFE1E3E6;
end;

procedure TFrameAttachmentPinnedMessage.SetMessageId(const Value: Int64);
begin
  FMessageId := Value;
end;

procedure TFrameAttachmentPinnedMessage.SetText(const Value: string);
begin
  FText := Value;
  LabelText.Text := FText;
end;

end.

