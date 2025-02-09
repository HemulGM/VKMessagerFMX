﻿unit ChatFMX.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Objects, ChatFMX.Frame.Chat, FMX.Controls.Presentation,
  FMX.Edit, FMX.StdCtrls, System.ImageList, FMX.ImgList, FMX.SVGIconImageList,
  FMX.Effects, FMX.Filter.Effects, ChatFMX.DM.Res, VK.API, VK.Components,
  VK.Entity.Conversation, System.Messaging, VK.Types,
  System.Generics.Collections, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  ChatFMX.Frame.Loading, VK.UserEvents, VK.Entity.Common.ExtendedList,
  System.Sensors, ChatFMX.View.ChatItem, System.Json;

type
  TChats = class(TObjectList<TFrameChat>)
    function FindChat(const PeerId: TVkPeerId; var Frame: TFrameChat): Boolean;
  end;

  TListBoxLoading = class(TListBoxItem)
  end;

  TMyHint = class(THint)
  protected
    procedure SetEnabled(const Value: Boolean); override;
  public
    procedure SetPosition(const X, Y: Single); override;
    procedure SetHint(const AString: string); override;
  end;

  THintHelper = class helper for THint
    class procedure Clear;
  end;

  TFormMain = class(TForm)
    LayoutClient: TLayout;
    HorzScrollBoxContent: THorzScrollBox;
    StyleBook: TStyleBook;
    RectangleBG: TRectangle;
    VK: TVK;
    LayoutChat: TLayout;
    LineBevel: TLine;
    LayoutNoChat: TLayout;
    Layout2: TLayout;
    Path1: TPath;
    Text1: TText;
    LayoutChatFrames: TLayout;
    LayoutChats: TLayout;
    ListBoxChats: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    RectangleHead: TRectangle;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    RectangleFooter: TRectangle;
    LabelChatsMode: TLabel;
    LayoutHeader: TLayout;
    RectangleHeader: TRectangle;
    CircleAvatar: TCircle;
    LayoutLoading: TLayout;
    RectangleLoadBG: TRectangle;
    PathSplashLogo: TPath;
    LabelLogoSubTitle: TLabel;
    LayoutError: TLayout;
    Rectangle2: TRectangle;
    Label2: TLabel;
    ButtonRelogin: TButton;
    PanelLoader: TPanel;
    LayoutLogo: TLayout;
    Path3: TPath;
    Path4: TPath;
    Path5: TPath;
    LayoutSplash: TLayout;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    LayoutChatsLoading: TLayout;
    LayoutChatLoadingAni: TLayout;
    FrameLoading1: TFrameLoading;
    Memo1: TMemo;
    LayoutAdaptive: TLayout;
    UserEvents: TVkUserEvents;
    LayoutLogin: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    ButtonLogin: TButton;
    LayoutHeadContent: TLayout;
    PopupHint: TPopup;
    RectangleHint: TRectangle;
    LabelHint: TLabel;
    TimerHint: TTimer;
    TimerHintClose: TTimer;
    ShadowEffect1: TShadowEffect;
    RectangleHintArrow: TRectangle;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VKAuth(Sender: TObject; Url: string; var Token: string; var TokenExpiry: Int64; var ChangePasswordHash: string);
    procedure VKLogin(Sender: TObject);
    procedure LabelChatsModeClick(Sender: TObject);
    procedure ListBoxChatsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ButtonReloginClick(Sender: TObject);
    procedure VKError(Sender: TObject; E: Exception; Code: Integer; Text: string);
    procedure Path3Click(Sender: TObject);
    procedure VKLog(Sender: TObject; const Value: string);
    procedure UserEventsUserOffline(Sender: TObject; UserId: TVkPeerId; InactiveUser: Boolean; TimeStamp: TDateTime);
    procedure UserEventsUserOnline(Sender: TObject; UserId: TVkPeerId; VkPlatform: TVkPlatform; TimeStamp: TDateTime);
    procedure UserEventsNewMessage(Sender: TObject; MessageData: TMessageData);
    procedure UserEventsEditMessage(Sender: TObject; MessageData: TMessageData);
    procedure UserEventsDeleteMessages(Sender: TObject; PeerId: TVkPeerId; LocalId: Int64);
    procedure UserEventsReadMessages(Sender: TObject; Incoming: Boolean; PeerId: TVkPeerId; LocalId: Int64);
    procedure UserEventsChangeMessageFlags(Sender: TObject; MessageChangeData: TMessageChangeData);
    procedure UserEventsRecoverMessages(Sender: TObject; PeerId: TVkPeerId; LocalId: Int64);
    procedure VKNeedGeoLocation(Sender: TObject; var Coord: TLocationCoord2D);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure CircleAvatarClick(Sender: TObject);
    procedure VKCaptcha(Sender: TObject; const CaptchaURL: string; var Answer: string);
    procedure ListBoxChatsCompare(Item1, Item2: TListBoxItem; var Result: Integer);
    procedure UserEventsChangeConversationMajorId(Sender: TObject; PeerId: TVkPeerId; const NewId: Int64);
    procedure UserEventsChangeConversationMinorId(Sender: TObject; PeerId: TVkPeerId; const NewId: Int64);
    procedure UserEventsUsersTyping(Sender: TObject; Data: TChatTypingData);
    procedure UserEventsUserTyping(Sender: TObject; UserId: TVkPeerId; ChatId: Int64);
    procedure UserEventsUnhandledEvents(Sender: TObject; const JSON: TJSONValue);
    procedure TimerHintTimer(Sender: TObject);
    procedure TimerHintCloseTimer(Sender: TObject);
  private
    FToken: string;
    FChangePasswordHash: string;
    FTokenExpiry: Int64;
    FUnreadOnly: Boolean;
    FLoading: Boolean;
    FListChatsOffset: Integer;
    FListChatsOffsetEnd: Boolean;
    FChats: TChats;
    FLoadingItem: TListBoxLoading;
    FAllowLocation: Boolean;
    FLocation: TLocationCoord2D;
    procedure FOnReadyAvatar(const Sender: TObject; const M: TMessage);
    procedure FOnChatItemClick(Sender: TObject);
   {$IFDEF ADAPTIVE}
    procedure FOnChatItemTap(Sender: TObject; const Point: TPointF);
    procedure FOnBackAdaptive(Sender: TObject);
    {$ENDIF}
    procedure LoadConversationsAsync;
    procedure CreateChatItem(Chat: TVkConversationItem; Data: IExtended);
    procedure SetUnreadOnly(const Value: Boolean);
    procedure FOnLog(Sender: TObject; Value: string);
    procedure EndOfChats;
    procedure Reload;
    procedure LoadChat(PeerId: TVkPeerId);
    function CreateChat(PeerId: TVkPeerId): TFrameChat;
    procedure ShowChat(Frame: TFrameChat);
    procedure Login;
    procedure LoadDone;
    procedure DoErrorLogin;
    procedure CreateLoadingItem;
    procedure ClearChatList;
    procedure Logout;
    procedure FOnChatChangeSort(Sender: TObject);
    procedure FOnChangeMessage(const Sender: TObject; const M: TMessage);
    function FindChat(const PeerId: TVkPeerId; var ChatItem: TListBoxItemChat): Boolean;
    procedure LoadConversationAsync(WithMessageId: Int64);
    procedure FOnAppHint(Sender: TObject);
    procedure FOnHintOpacity(Sender: TObject);
  public
    property UnreadOnly: Boolean read FUnreadOnly write SetUnreadOnly;
    destructor Destroy; override;
  end;

const
  ChatItemCountPerQuery = 30;

var
  FormMain: TFormMain;

implementation

uses
  System.Math, System.Threading, VK.Errors, VK.FMX.OAuth2, VK.FMX.Captcha,
  System.IOUtils, VK.Clients, VK.Messages, ChatFMX.PreviewManager, FMX.Ani,
  HGM.FMX.SmoothScroll, ChatFMX.Events, FMX.Controls.Win, ChatFMX.Utils;

{$R *.fmx}

procedure TFormMain.FOnChatItemClick(Sender: TObject);
var
  Item: TListBoxItemChat absolute Sender;
begin
  Item.IsSelected := True;
  LoadChat(Item.ConversationId);
end;

{$IFDEF ADAPTIVE}
procedure TFormMain.FOnChatItemTap(Sender: TObject; const Point: TPointF);
begin
  FOnChatItemClick(Sender);
end;

procedure TFormMain.FOnBackAdaptive(Sender: TObject);
begin
  if LayoutChats.Visible then
  begin
    LayoutChats.Visible := False;
    LayoutChat.Visible := True;
  end
  else
  begin
    LayoutChats.Visible := True;
    LayoutChat.Visible := False;
  end;
end;
{$ENDIF}

procedure TFormMain.FOnLog(Sender: TObject; Value: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      Memo1.Lines.Add(Value);
    end);
end;

procedure TFormMain.FOnReadyAvatar(const Sender: TObject; const M: TMessage);
var
  Data: TMessagePreview absolute M;
begin
  if Data.Value.Url <> VK.UserPhoto100 then
    Exit;
  try
    CircleAvatar.Fill.Bitmap.Bitmap.LoadFromFile(Data.Value.FileName);
    CircleAvatar.Fill.Kind := TBrushKind.Bitmap;
    CircleAvatar.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  except
    CircleAvatar.Fill.Kind := TBrushKind.Solid;
  end;
  TPreview.Instance.Unsubscribe(FOnReadyAvatar);
end;

procedure TFormMain.Login;
begin
  try
    VK.Login;
  except
    TThread.Queue(nil, DoErrorLogin);
  end;
end;

procedure TFormMain.Path3Click(Sender: TObject);
begin
  Memo1.Visible := not Memo1.Visible;
end;

procedure TFormMain.FOnAppHint(Sender: TObject);
begin
  TimerHint.Enabled := False;
  if Application.Hint.IsEmpty then
  begin
    PopupHint.IsOpen := False;
    Exit;
  end;
  if PopupHint.IsOpen then
    TimerHintTimer(nil)
  else
    TimerHint.Enabled := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Application.OnHint := FOnAppHint;
  {$IFDEF ADAPTIVE AND MSWINDOWS}
  Width := 500;
  {$ENDIF}
  {$IFDEF ADAPTIVE}
  ListBoxChats.ShowScrollBars := False;
  RectangleBG.Visible := False;
  LineBevel.Visible := False;
  LayoutChatFrames.Margins.Left := 0;
  LayoutHeader.Visible := False;
  RectangleHead.Sides := [];
  RectangleHead.Corners := [];
  RectangleFooter.Sides := [];
  RectangleFooter.Corners := [];
  ListBoxChats.Margins.Left := 0;
  LayoutAdaptive.Visible := True;
  HorzScrollBoxContent.Visible := False;
  LayoutChat.Visible := False;
  LayoutChat.Parent := LayoutAdaptive;
  LayoutChats.Parent := LayoutAdaptive;
  LayoutChats.Align := TAlignLayout.Client;
  LayoutChat.Align := TAlignLayout.Client;
  {$ENDIF}
  FAllowLocation := False;
  FLoading := True;
  FLoadingItem := nil;
  LayoutLoading.Visible := True;
  LayoutLoading.BringToFront;
  HorzScrollBoxContent.Visible := False;
  LayoutAdaptive.Visible := False;
  PanelLoader.StylesData['left.Enabled'] := True;
  PanelLoader.Visible := True;
  FChats := TChats.Create;
  LayoutError.Visible := False;
  ListBoxChats.AniCalculations.Animation := True;
  TPreview.Instance.OnLog := FOnLog;
  VK.Application := TVkApplicationData.VKAdmin;
  try
    if TFile.Exists('token.tmp') then
      VK.Token := TFile.ReadAllText('token.tmp');
  except
    //
  end;
  Event.Subscribe(TEventNewMessage, FOnChangeMessage);
  TTask.Run(Login);
  //LoadDone;
end;

function TFormMain.FindChat(const PeerId: TVkPeerId; var ChatItem: TListBoxItemChat): Boolean;
begin
  for var i := 0 to Pred(ListBoxChats.Count) do
    if ListBoxChats.ListItems[i] is TListBoxItemChat then
    begin
      ChatItem := (ListBoxChats.ListItems[i] as TListBoxItemChat);
      if NormalizePeerId(ChatItem.ConversationId) = PeerId then
        Exit(True);
    end;
  ChatItem := nil;
  Result := False;
end;

procedure TFormMain.FOnChangeMessage(const Sender: TObject; const M: TMessage);
var
  Event: TEventNewMessage absolute M;
  ChatItem: TListBoxItemChat;
begin
  if not FindChat(Event.Data.PeerId, ChatItem) then
    TTask.Run(
      procedure
      begin
        LoadConversationAsync(Event.Data.MessageId)
      end);
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  LayoutClient.Width := Max(Min(1000, ClientWidth), 800) - 40;
  LayoutHeadContent.Width := Min(1000, ClientWidth) - 40;
end;

procedure TFormMain.FOnChatChangeSort(Sender: TObject);
begin
  var Selected := ListBoxChats.Selected;
  ListBoxChats.BeginUpdate;
  try
    ListBoxChats.Sorted := False;
    ListBoxChats.Sorted := True;
    ListBoxChats.ClearSelection;
    if Assigned(Selected) then
      Selected.IsSelected := True;
  finally
    ListBoxChats.EndUpdate;
  end;
end;

procedure TFormMain.CreateChatItem(Chat: TVkConversationItem; Data: IExtended);
var
  ListItem: TListBoxItemChat;
begin
  if FindChat(Chat.Conversation.Peer.Id, ListItem) then
    Exit;
  ListItem := TListBoxItemChat.Create(ListBoxChats, VK);
  ListItem.Height := 63;
  ListBoxChats.AddObject(ListItem);
  ListItem.Fill(Chat, Data);
  ListItem.OnChangeSortId := FOnChatChangeSort;
  {$IFNDEF ADAPTIVE}
  ListItem.OnClick := FOnChatItemClick;
  {$ELSE}
    {$IFDEF MSWINDOWS}
  ListItem.OnClick := FOnChatItemClick;
    {$ELSE}
  ListItem.OnTap := FOnChatItemTap;
    {$ENDIF}
  {$ENDIF}
  ListItem.DisableDisappear := True;
  ListItem.ApplyStyle;
end;

procedure TFormMain.LabelChatsModeClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  FLoading := True;
  UnreadOnly := not UnreadOnly;
  TTask.Run(LoadConversationsAsync);
end;

procedure TFormMain.EndOfChats;
begin
  if FLoading then
    Exit;
  FLoading := True;
  if not FListChatsOffsetEnd then
  begin
    Inc(FListChatsOffset, ChatItemCountPerQuery);
    TTask.Run(LoadConversationsAsync);
  end;
end;

procedure TFormMain.ListBoxChatsCompare(Item1, Item2: TListBoxItem; var Result: Integer);
var
  L: TListBoxItemChat absolute Item1;
  R: TListBoxItemChat absolute Item2;
begin
  if (Item1 is TListBoxItemChat) and (Item2 is TListBoxItemChat) then
  begin
    Result := R.SortMajorId - L.SortMajorId;
    if Result = 0 then
      Result := R.SortMinorId - L.SortMinorId
  end
  else
    Result := 1;
end;

procedure TFormMain.ListBoxChatsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  if Assigned(FLoadingItem) then
    LayoutChatLoadingAni.Position.Y := -(NewViewportPosition.Y - FLoadingItem.Position.Y)
  else
    LayoutChatLoadingAni.Position.Y := -LayoutChatLoadingAni.Height;
  if FLoading then
    Exit;
  if NewViewportPosition.Y = 0 then
    Exit;
  if NewViewportPosition.Y + ListBoxChats.Height >= (ListBoxChats.ContentBounds.Height - ListBoxChats.Height) then
    EndOfChats;
end;

procedure TFormMain.ButtonReloginClick(Sender: TObject);
begin
  PanelLoader.Visible := True;
  LayoutError.Visible := False;
  LayoutLogin.Visible := False;
  TTask.Run(
    procedure
    begin
      Sleep(2000);
      Login;
    end);
end;

function TFormMain.CreateChat(PeerId: TVkPeerId): TFrameChat;
begin
  LayoutNoChat.Visible := False;
  Result := TFrameChat.Create(Self, VK);
  Result.Visible := False;
  Result.Parent := LayoutChatFrames;
  Result.Align := TAlignLayout.Client;
  Result.Load(PeerId);
  {$IFDEF ADAPTIVE}
  Result.OnBack := FOnBackAdaptive;
  {$ENDIF}
  FChats.Add(Result);
  if FChats.Count > 30 then
    FChats.Delete(0);
end;

procedure TFormMain.ShowChat(Frame: TFrameChat);
begin
  for var Control in LayoutChatFrames.Controls do
    Control.Visible := Control = Frame;
  Frame.RecalcSize;
  {$IFDEF ADAPTIVE}
  LayoutChats.Visible := False;
  LayoutChat.Visible := True;
  {$ENDIF}
end;

procedure TFormMain.TimerHintCloseTimer(Sender: TObject);
begin
  TimerHintClose.Enabled := False;
  if PopupHint.IsOpen then
    PopupHint.IsOpen := False;
end;

procedure TFormMain.TimerHintTimer(Sender: TObject);
begin
  TimerHintClose.Enabled := False;
  TimerHint.Enabled := False;
  LabelHint.Text := Application.Hint;
  LabelHint.RecalcSize;
  PopupHint.Width := LabelHint.Width + RectangleHint.Padding.Left + RectangleHint.Padding.Right;
  var Obj := ObjectAtPoint(Screen.MousePos);
  if (Obj <> nil) and (Obj is TControl) then
  begin
    if (Obj as TControl).Tag = 0 then
    begin
      RectangleHintArrow.Position.Y := -4;
      PopupHint.Placement := TPlacement.absolute;
      var Pt := (Obj as TControl).AbsoluteRect.TopLeft;

      Pt.Offset((Obj as TControl).Width / 2 - 20, (Obj as TControl).Height + 10);
      Pt := ClientToScreen(Pt);
      var PR := TRectF.Create(Pt, PopupHint.Width, PopupHint.Height);
      PopupHint.PlacementRectangle.Rect := PR;
    end
    else
    begin
      PopupHint.Placement := TPlacement.absolute;
      RectangleHintArrow.Position.Y := RectangleHint.Height - 10;
      var Pt := (Obj as TControl).AbsoluteRect.TopLeft;

      Pt.Offset((Obj as TControl).Width / 2 - 20, - PopupHint.Height);
      Pt := ClientToScreen(Pt);
      var PR := TRectF.Create(Pt, PopupHint.Width, PopupHint.Height);
      PopupHint.PlacementRectangle.Rect := PR;
    end;
  end
  else
  begin
    PopupHint.Placement := TPlacement.absolute;
    var Pt := Screen.MousePos;
    Pt.Offset(-5, 20);
    PopupHint.PlacementRectangle.Rect := TRectF.Create(Pt, PopupHint.Width, PopupHint.Height);
  end;

  if not PopupHint.IsOpen then
  begin
    PopupHint.Popup;
    RectangleHint.Opacity := 0.1;
    TAnimator.AnimateFloat(RectangleHint, 'Opacity', 1, FOnHintOpacity);
    ShadowEffect1.UpdateParentEffects;
  end;
  TimerHintClose.Enabled := True;
end;

procedure TFormMain.FOnHintOpacity(Sender: TObject);
begin
  ShadowEffect1.UpdateParentEffects;
end;

procedure TFormMain.UserEventsChangeConversationMajorId(Sender: TObject; PeerId: TVkPeerId; const NewId: Int64);
begin
  Event.Send(TEventChangeSort.Create(PeerId, NewId, True));
end;

procedure TFormMain.UserEventsChangeConversationMinorId(Sender: TObject; PeerId: TVkPeerId; const NewId: Int64);
begin
  Event.Send(TEventChangeSort.Create(PeerId, NewId, False));
end;

procedure TFormMain.UserEventsChangeMessageFlags(Sender: TObject; MessageChangeData: TMessageChangeData);
begin
  Event.Send(TEventMessageChange.Create(MessageChangeData));
end;

procedure TFormMain.UserEventsDeleteMessages(Sender: TObject; PeerId: TVkPeerId; LocalId: Int64);
begin
  Event.Send(TEventDeleteMessage.Create(PeerId, LocalId));
end;

procedure TFormMain.UserEventsEditMessage(Sender: TObject; MessageData: TMessageData);
begin
  Event.Send(TEventEditMessage.Create(MessageData));
end;

procedure TFormMain.UserEventsNewMessage(Sender: TObject; MessageData: TMessageData);
begin
  Event.Send(TEventNewMessage.Create(MessageData));
end;

procedure TFormMain.UserEventsReadMessages(Sender: TObject; Incoming: Boolean; PeerId: TVkPeerId; LocalId: Int64);
begin
  Event.Send(TEventReadMessages.Create(Incoming, PeerId, LocalId));
end;

procedure TFormMain.UserEventsRecoverMessages(Sender: TObject; PeerId: TVkPeerId; LocalId: Int64);
begin
  Event.Send(TEventRecoverMessage.Create(PeerId, LocalId));
end;

procedure TFormMain.UserEventsUnhandledEvents(Sender: TObject; const JSON: TJSONValue);
begin
  var JS := JSON.Format;
  TThread.Queue(nil,
    procedure
    begin
      ShowMessage('Unhandled event: '#13#10 + JS);
    end);
end;

procedure TFormMain.UserEventsUserOffline(Sender: TObject; UserId: TVkPeerId; InactiveUser: Boolean; TimeStamp: TDateTime);
begin
  Event.Send(TEventUserStatus.Create(UserId, False));
end;

procedure TFormMain.UserEventsUserOnline(Sender: TObject; UserId: TVkPeerId; VkPlatform: TVkPlatform; TimeStamp: TDateTime);
begin
  Event.Send(TEventUserStatus.Create(UserId, False, VkPlatform));
end;

procedure TFormMain.UserEventsUsersTyping(Sender: TObject; Data: TChatTypingData);
begin
  Event.Send(TEventUsersTyping.Create(Data));
end;

procedure TFormMain.UserEventsUserTyping(Sender: TObject; UserId: TVkPeerId; ChatId: Int64);
begin
  var Data: TChatTypingData;
  Data.UserIds := [UserId];
  Data.PeerId := ChatId;
  Event.Send(TEventUsersTyping.Create(Data));
end;

procedure TFormMain.LoadChat(PeerId: TVkPeerId);
var
  Frame: TFrameChat;
begin
  if not FChats.FindChat(PeerId, Frame) then
    Frame := CreateChat(PeerId);
  ShowChat(Frame);
end;

procedure TFormMain.LoadConversationAsync(WithMessageId: Int64);
var
  Items: TVkConversationItems;
  Params: TVkParamsConversationsGet;
begin
  Params.Extended;
  Params.Count(1);
  Params.StartMessageId(WithMessageId);
  Params.Fields(
    [TVkExtendedField.Photo50, TVkExtendedField.Verified, TVkExtendedField.OnlineInfo,
    TVkExtendedField.FirstNameAcc, TVkExtendedField.LastNameAcc]);
  if FUnreadOnly then
    Params.Filter(TVkConversationFilter.Unread);
  try
    if VK.Messages.GetConversations(Items, Params) then
    begin
      var Extended: IExtended := Items;
      TThread.Synchronize(nil,
        procedure
        begin
          ListBoxChats.BeginUpdate;
          try
            for var Item in Items.Items do
              CreateChatItem(Item, Extended);
          finally
            ListBoxChats.EndUpdate;
            ListBoxChats.Sorted := True;
          end;
        end);
    end;
  except
    //
  end;
end;

procedure TFormMain.LoadConversationsAsync;
var
  Items: TVkConversationItems;
  Params: TVkParamsConversationsGet;
begin
  Params.Extended;
  Params.Offset(FListChatsOffset);
  Params.Count(ChatItemCountPerQuery);
  Params.Fields(
    [TVkExtendedField.Photo50, TVkExtendedField.Verified, TVkExtendedField.OnlineInfo,
    TVkExtendedField.FirstNameAcc, TVkExtendedField.LastNameAcc]);
  if FUnreadOnly then
    Params.Filter(TVkConversationFilter.Unread);
  try
    if VK.Messages.GetConversations(Items, Params) then
    begin
      var Extended: IExtended := Items;
      if Length(Items.Items) < ChatItemCountPerQuery then
        FListChatsOffsetEnd := True;
      TThread.Synchronize(nil,
        procedure
        begin
          ListBoxChats.BeginUpdate;
          try
            for var Item in Items.Items do
              CreateChatItem(Item, Extended);
            if FListChatsOffsetEnd then
            begin
              LayoutChatLoadingAni.Position.Y := -LayoutChatLoadingAni.Height;
              FLoadingItem.Free;
              FLoadingItem := nil;
            end
            else if Assigned(FLoadingItem) then
              FLoadingItem.Index := ListBoxChats.Count;
          finally
            ListBoxChats.EndUpdate;
            ListBoxChats.Sorted := True;
          end;
          FLoading := False;
        end);
    end;
  except
    Dec(FListChatsOffset);
    if FListChatsOffset < 0 then
      FListChatsOffset := 0;
    FLoading := False;
  end;
end;

procedure TFormMain.CreateLoadingItem;
begin
  FLoadingItem := TListBoxLoading.Create(ListBoxChats);
  FLoadingItem.Text := '';
  FLoadingItem.DisableDisappear := True;
  FLoadingItem.StyleLookup := 'item_loading';
  FLoadingItem.Height := 40;
  ListBoxChats.AddObject(FLoadingItem);
end;

procedure TFormMain.CircleAvatarClick(Sender: TObject);
begin
  Logout;
end;

procedure TFormMain.Logout;
begin
  {$IFDEF MSWINDOWS}
  DeleteCache('vk.com');
  {$ENDIF}
  VK.Logout;
  UserEvents.Stop;
  FChats.Clear;
  ListBoxChats.Clear;
  try
    TFile.Delete('token.tmp');
  except
  end;
  LayoutLoading.Opacity := 1;
  LayoutLoading.Visible := True;
  LayoutError.Visible := False;
  PanelLoader.Visible := False;
  HorzScrollBoxContent.Visible := False;
  LayoutAdaptive.Visible := False;
  LayoutLogin.Visible := True;
end;

procedure TFormMain.ClearChatList;
begin
  FLoadingItem := nil;
  ListBoxChats.Clear;
  CreateLoadingItem;
end;

procedure TFormMain.SetUnreadOnly(const Value: Boolean);
begin
  FUnreadOnly := Value;
  FListChatsOffset := 0;
  FListChatsOffsetEnd := False;
  ClearChatList;
  case FUnreadOnly of
    True:
      LabelChatsMode.Text := 'Показать все';
    False:
      LabelChatsMode.Text := 'Показать непрочитанные';
  end;
end;

procedure TFormMain.VKAuth(Sender: TObject; Url: string; var Token: string; var TokenExpiry: Int64; var ChangePasswordHash: string);
begin
  if FToken.IsEmpty then
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        TFormFMXOAuth2.Execute(Url,
          procedure(Form: TFormFMXOAuth2)
          begin
            FToken := Form.Token;
            FTokenExpiry := Form.TokenExpiry;
            FChangePasswordHash := Form.ChangePasswordHash;
            if not FToken.IsEmpty then
              TTask.Run(Login)
            else
              DoErrorLogin;
          end);
      end);
  end
  else
  begin
    Token := FToken;
    TokenExpiry := FTokenExpiry;
    ChangePasswordHash := FChangePasswordHash;
  end;
end;

procedure TFormMain.VKCaptcha(Sender: TObject; const CaptchaURL: string; var Answer: string);
begin
  TFormFMXCaptcha.Execute(CaptchaURL, Answer);
end;

destructor TFormMain.Destroy;
begin
  Hide;
  Event.Unsubscribe(TEventEditMessage, FOnChangeMessage);
  TThread.RemoveQueuedEvents(nil);
  while VK.Handler.Executing do
    Application.ProcessMessages;
  TPreview.Instance.Unsubscribe(FOnReadyAvatar);
  FChats.Free;
  inherited;
end;

procedure TFormMain.DoErrorLogin;
begin
  if not VK.Token.IsEmpty then
  begin
    FToken := '';
    VK.Token := '';
    try
      TFile.Delete('token.tmp');
    except
    end;
    LayoutError.Visible := False;
    TTask.Run(Login);
    Exit;
  end;
  LayoutLogin.Visible := False;
  LayoutLoading.Opacity := 1;
  LayoutLoading.Visible := True;
  LayoutError.Visible := True;
  PanelLoader.Visible := False;
  HorzScrollBoxContent.Visible := False;
  LayoutAdaptive.Visible := False;
end;

procedure TFormMain.VKError(Sender: TObject; E: Exception; Code: Integer; Text: string);
begin
  if Code = VK_ERROR_INVALID_TOKEN then
  begin
    FToken := '';
    VK.Token := '';
    TTask.Run(Login);
    Exit;
  end
  else if not VK.IsLogin then
    DoErrorLogin;
end;

procedure TFormMain.LoadDone;
begin
  {$IFNDEF ADAPTIVE}
  TAnimator.AnimateFloatWait(LayoutLoading, 'Opacity', 0);
  {$ENDIF}
  LayoutLoading.Visible := False;
  {$IFNDEF ADAPTIVE}
  HorzScrollBoxContent.Visible := True;
  {$ELSE}
  LayoutAdaptive.Visible := True;
  {$ENDIF}
end;

procedure TFormMain.LocationSensorLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
begin
  FAllowLocation := True;
  FLocation := NewLocation;
end;

procedure TFormMain.Reload;
begin
  ClearChatList;
  FListChatsOffset := 0;
  FListChatsOffsetEnd := False;
  FLoading := True;
  TTask.Run(
    procedure
    begin
      VK.LoadUserInfo;
      TThread.Queue(nil,
        procedure
        begin
          TPreview.Instance.Subscribe(VK.UserPhoto100, FOnReadyAvatar);
          Caption := 'VK Messenger [' + VK.UserName + ']';
        end);
      LoadConversationsAsync;
      UserEvents.Start;
      Sleep(500);
      TThread.Queue(nil,
        procedure
        begin
          LoadDone;
        end);
    end);
end;

procedure TFormMain.VKLog(Sender: TObject; const Value: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      Memo1.Lines.Add(Value);
    end);
end;

procedure TFormMain.VKLogin(Sender: TObject);
begin
  try
    TFile.WriteAllText('token.tmp', VK.Token);
  except
    //
  end;
  TThread.Queue(nil, Reload);
end;

procedure TFormMain.VKNeedGeoLocation(Sender: TObject; var Coord: TLocationCoord2D);
begin
  if FAllowLocation then
    Coord := FLocation;
end;

{ TChats }

function TChats.FindChat(const PeerId: TVkPeerId; var Frame: TFrameChat): Boolean;
begin
  for var Item in Self do
    if Item.ConversationId = PeerId then
    begin
      Frame := Item;
      Exit(True);
    end;
  Result := False;
end;

{ THintHelper }

class procedure THintHelper.Clear;
begin
  with Self do
    FClassRegistry := [];
end;

{ TMyHint }

procedure TMyHint.SetEnabled(const Value: Boolean);
begin
  inherited;
end;

procedure TMyHint.SetHint(const AString: string);
begin
  inherited;
end;

procedure TMyHint.SetPosition(const X, Y: Single);
begin
  inherited;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
  THint.Clear;
  THint.RegisterClass(TMyHint);

end.

