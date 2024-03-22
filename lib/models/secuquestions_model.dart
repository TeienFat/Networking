class SecuQuestion {
  String? question_id;
  String? content;

  SecuQuestion({required this.question_id, required this.content});
}

List<SecuQuestion> secuQuestions = [
  SecuQuestion(
      question_id: 'SQ01', content: "Tên người thân gần nhất của bạn là gì?"),
  SecuQuestion(
      question_id: 'SQ02', content: "Tên trường học trung học của bạn là gì?"),
  SecuQuestion(
      question_id: 'SQ03', content: "Tên người bạn thân nhất của bạn là gì?"),
  SecuQuestion(question_id: 'SQ04', content: "Tên quê quán của bố mẹ bạn?"),
  SecuQuestion(
      question_id: 'SQ05', content: "Tên thương hiệu xe hơi mà bạn ưa thích?"),
  SecuQuestion(
      question_id: 'SQ06', content: "Tên công việc mà bạn muốn làm nhất"),
  SecuQuestion(question_id: 'SQ07', content: "Tên món ăn mà bạn thích nhất?"),
  SecuQuestion(
      question_id: 'SQ08', content: "Tên nhân vật hư cấu mà bạn ngưỡng mộ?"),
  SecuQuestion(question_id: 'SQ09', content: "Tên ngày lễ mà bạn thích nhất?"),
  SecuQuestion(
      question_id: 'SQ10', content: "Tên thành phố đầu tiên mà bạn đã đến?"),
];
