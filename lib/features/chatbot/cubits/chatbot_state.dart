part of 'chatbot_cubit.dart';

sealed class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object> get props => [];
}

final class ChatbotInitial extends ChatbotState {}
