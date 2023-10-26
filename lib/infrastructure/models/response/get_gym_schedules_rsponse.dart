class GetGymSchedulesResponse {
	String? operationResult;
	Schedule? schedule;

	GetGymSchedulesResponse({this.operationResult, this.schedule});

	GetGymSchedulesResponse.fromJson(Map<String, dynamic> json) {
		operationResult = json['operationResult'];
		schedule = json['object'] != null ? Schedule.fromJson(json['object']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['operationResult'] = operationResult;
		if (schedule != null) {
      data['object'] = schedule!.toJson();
    }
		return data;
	}
}

class Schedule {
	List<Day>? l20231003;
	List<Day>? l20231011;
	List<Day>? l20231012;

	Schedule({this.l20231003, this.l20231011, this.l20231012});

	Schedule.fromJson(Map<String, dynamic> json) {
		if (json['2023-10-03'] != null) {
			l20231003 = <Day>[];
			json['2023-10-03'].forEach((v) { l20231003!.add( Day.fromJson(v)); });
		}
		if (json['2023-10-11'] != null) {
			l20231011 = <Day>[];
			json['2023-10-11'].forEach((v) { l20231011!.add( Day.fromJson(v)); });
		}
		if (json['2023-10-12'] != null) {
			l20231012 = <Day>[];
			json['2023-10-12'].forEach((v) { l20231012!.add( Day.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data =  Map<String, dynamic>();
		if (l20231003 != null) {
      data['2023-10-03'] = l20231003!.map((v) => v.toJson()).toList();
    }
		if (l20231011 != null) {
      data['2023-10-11'] = l20231011!.map((v) => v.toJson()).toList();
    }
		if (l20231012 != null) {
      data['2023-10-12'] = l20231012!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Day {
	int? id;
	String? date;
	String? description;

	Day({this.id, this.date, this.description});

	Day.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		date = json['date'];
		description = json['description'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['date'] = this.date;
		data['description'] = this.description;
		return data;
	}
}