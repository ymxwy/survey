/*创建数据库*/
drop database surveys;
create database surveys;
use surveys;
/*创建用户表user*/
CREATE TABLE `surveys`.`user` (
  `user_id` char(18) NOT NULL COMMENT '编号',
  `user_email` varchar(20) unique COMMENT '邮箱名称',
  `user_name` varchar(20) unique COMMENT '登录名',
  `user_nickname` varchar(20) NOT NULL COMMENT '昵称',
  `password` varchar(14) NOT NULL COMMENT '密码,长度为8-14位',
  `create_date` datetime default now() COMMENT '创建时间',
  `last_login_time` date NULL COMMENT '最后登录时间',
  `user_status` int default 0 COMMENT '状态',
  `cremark` varchar(20) NULL COMMENT '备注',
  PRIMARY KEY (`user_id`));
/*创建资源表resource*/
CREATE TABLE `surveys`.`resource` (
  `resource_id` char(18) NOT NULL COMMENT '资源id',
  `path` varchar(45) NOT NULL COMMENT '资源路径,请求路径,如:/工程名/模块/user.do',
  `desc` varchar(45) NULL COMMENT '描述,如:用户添加、用户修改',
  PRIMARY KEY (`Resource_id`));
/*创建权限表privilege*/
CREATE TABLE `surveys`.`privilege` (
  `privilege_id` char(18) NOT NULL COMMENT '角色id',
  `resource_id` char(18) NOT NULL COMMENT '与资源表进行关联',
  `name` varchar(20) NOT NULL COMMENT '功能介绍',
  `desc` varchar(20) NULL COMMENT '对权限进行介绍',
  PRIMARY KEY (`Privilege_id`));
	/*主表权限表resource和从表privilege通过resource_id建立引用关系*/
	/*ALTER TABLE privilege ADD CONSTRAINT FK_resources_id
	FOREIGN KEY(resource_id) REFERENCES resource(resource_id);*/
/*创建角色表role*/
CREATE TABLE `surveys`.`role` (
  `role_id` char(18) NOT NULL COMMENT '角色id',
  `name` varchar(20) NOT NULL COMMENT '简短名称,功能介绍',
  `desc` varchar(20) NULL COMMENT '描述，具体功能介绍',
  PRIMARY KEY (`role_id`));
/*角色和权限关联表role_privilege*/
CREATE TABLE `surveys`.`role_privilege` (
  `rp_id` char(18) NOT NULL COMMENT '主键',
  `role_id` char(18) NOT NULL COMMENT '与角色表进行关联',
  `privilege_id` varchar(45) NOT NULL COMMENT '与权限表进行关联',
  PRIMARY KEY (`rp_id`));
	/*主表角色表role和从表role_privilege通过role_id建立引用关系*/
	/*ALTER TABLE role_privilege ADD CONSTRAINT FK_rp_role_id
	FOREIGN KEY(role_id) REFERENCES role(role_id);*/
	/*主表角色表privilege和从表role_privilege通过role_id建立引用关系*/
	/*ALTER TABLE role_privilege ADD CONSTRAINT FK_rp_privilege_id
	FOREIGN KEY(privilege_id) REFERENCES privilege(privilege_id);*/
/*用户角色表user_role*/
CREATE TABLE `surveys`.`user_role` (
  `ur_id` char(18) NOT NULL COMMENT '主键',
  `user_id` char(18) NOT NULL COMMENT '与用户表进行关联',
  `role_id` char(18) NOT NULL COMMENT '与角色表进行关联',
  PRIMARY KEY (`ur_id`));
	/*主表用户表user和从表user_role通过user_id建立引用关系*/
	/*ALTER TABLE user_role ADD CONSTRAINT FK_ur_user_id
	FOREIGN KEY(user_id) REFERENCES user(user_id);*/
	/*主表权限表role和从表user_role通过role_id建立引用关系*/
	/*ALTER TABLE user_role ADD CONSTRAINT FK_ur_role_id
	FOREIGN KEY(role_id) REFERENCES role(role_id);*/
/*创建问卷表survey*/
CREATE TABLE `surveys`.`survey` (
  `survey_id` char(18) NOT NULL COMMENT '问卷id',
  `join_num` int null COMMENT '参与答题人数',
  `heading_name` varchar(20) NOT NULL COMMENT '问卷标题',
  `create_date` datetime default now() COMMENT '第一时间创建时间',
  `end_time` datetime NULL COMMENT '发布后的时间',
  `html_path` varchar(255) NULL COMMENT '问卷访问路径',
  `survey_model` int NULL COMMENT '问卷模板即样式',
  `survey_name` varchar(255) NULL COMMENT '问卷调查名称即主题',
  `survey_state` int NULL COMMENT '问卷状态,如:0:设计,1:收集...',
  `cremark` varchar(20) NULL COMMENT '备注',
  PRIMARY KEY (`survey_id`));
/*用户和问卷关联表user_survey*/
CREATE TABLE `surveys`.`user_survey` (
  `uu_id` char(18) NOT NULL COMMENT '主键',
  `user_id` char(18) NOT NULL COMMENT '登录用户，与用户表关联',
  `survey_id` varchar(45) NOT NULL COMMENT '问卷id，用户拥有的问卷，与问卷表关联',
  PRIMARY KEY (`uu_id`));
	/*主表用户表user和从表user_survey通过user_id建立引用关系*/
	/*ALTER TABLE user_survey ADD CONSTRAINT FK_uu_user_id
	FOREIGN KEY(user_id) REFERENCES user(user_id);*/
	/*主表问卷表survey和从表user_role通过role_id建立引用关系*/
	/*ALTER TABLE user_survey ADD CONSTRAINT FK_uu_survey_id
	FOREIGN KEY(survey_id) REFERENCES survey(survey_id);*/
/*创建控件表control*/
CREATE TABLE `surveys`.`control` (
  `control_id` char(18) NOT NULL COMMENT '控件id',
  `survey_id` char(18) NOT NULL COMMENT '控件所属问卷，与问卷表关联',
  `control_type` int NOT NULL COMMENT '控件类型，如:1单选，2多选...',
  `control_title` varchar(20) NULL COMMENT '不同类型不同默认标题',
  `control_sequence` int NOT NULL COMMENT '一个问卷中控件的排序',
  `control_row_id` int NULL COMMENT '题目序号(问题间排序)',
  `required` int default 0 COMMENT '0为不必答，1为必答',
  `random_sequence` int default 0 COMMENT '0为不随机，1为随机',
  `associate_contact_property` varchar(20) NULL COMMENT '根据选项把内容关联到对应联系人属性中',
  PRIMARY KEY (`control_id`));

	
/*创建单选、多选、填空题逻辑设置表radio_checkbox_blank_logic_setting*/
CREATE TABLE `surveys`.`radio_checkbox_blank_logic_setting` (
  `rcb_logic_id` char(18) NOT NULL COMMENT '逻辑设置id',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `order_by_id` int NOT NULL COMMENT '要设置的对应问题选项',
  `accord_style` int NULL COMMENT '0为显示，1为跳转',
  `logical_execution` int NULL COMMENT '注意0下标为默认文本，中间为问题，最后两个其他逻辑设置',
  PRIMARY KEY (`rcb_logic_id`));
	/*主表控件表control和从表radio_checkbox_blank_logic_setting
		通过control_id建立引用关系*/
	/*ALTER TABLE radio_checkbox_blank_logic_setting 
	ADD CONSTRAINT FK_rcbls_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/

/*创建单选题表radio*/
CREATE TABLE `surveys`.`radio` (
  `radio_id` char(18) NOT NULL COMMENT '单选题id',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  PRIMARY KEY (`radio_id`));
	/*主表控件表control和从表radio通过control_id建立引用关系*/
	/*ALTER TABLE radio 
	ADD CONSTRAINT FK_r_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
/*创建单选题选项表radio_option*/
CREATE TABLE `surveys`.`radio_option` (
  `ro_id` char(18) NOT NULL COMMENT '主键',
  `radio_id` char(18) NOT NULL COMMENT '与单选题表关联，间接和控件表关联',
  `option_name` varchar(20) NULL COMMENT '选项名称',
  `order_by_id` int NULL COMMENT '对应控件选项下标',
  PRIMARY KEY (`ro_id`));
	/*主表单选题表radio和从表radio_option通过radio_id建立引用关系*/
	/*ALTER TABLE radio_option 
	ADD CONSTRAINT FK_ro_radio_id
	FOREIGN KEY(radio_id) REFERENCES radio(radio_id);*/

/*创建多选题表checkbox*/
CREATE TABLE `surveys`.`checkbox` (
  `checkbox_id` char(18) NOT NULL COMMENT '多选题id',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  PRIMARY KEY (`checkbox_id`));
	/*主表控件表control和从表radio通过control_id建立引用关系*/
	/*ALTER TABLE checkbox 
	ADD CONSTRAINT FK_c_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
/*创建多选题选项表checkbox_option*/
CREATE TABLE `surveys`.`checkbox_option` (
  `co_id` char(18) NOT NULL COMMENT '主键',
  `checkbox_id` char(18) NOT NULL COMMENT '与多选题表关联，间接和控件表关联',
  `option_name` varchar(20) NULL COMMENT '选项名称',
  `order_by_id` int NULL COMMENT '对应控件选项下标',
  PRIMARY KEY (`co_id`));
	/*主表多选题表checkbox和从表checkbox_option通过checkbox_id建立引用关系*/
	/*ALTER TABLE checkbox_option 
	ADD CONSTRAINT FK_ro_checkbox_id
	FOREIGN KEY(checkbox_id) REFERENCES checkbox(checkbox_id);*/

/*创建填空题表fillblank*/
CREATE TABLE `surveys`.`fillblank` (
  `fillblank_id` char(18) NOT NULL COMMENT '同上',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `fillblank_wide` int default 300 COMMENT '文本框宽度，单位字符',
  `fillblank_high` int default 1 COMMENT '文本高度，单位行',
  `fillblank_type` varchar(20) default '无校验' COMMENT '填写数据类型，可有多种类型',
  PRIMARY KEY (`fillblank_id`));
	/*主表控件表control和从表fillblank通过control_id建立引用关系*/
	/*ALTER TABLE fillblank 
	ADD CONSTRAINT FK_f_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/

/*创建评分题表score*/
CREATE TABLE `surveys`.`score` (
  `score_id` char(18) NOT NULL COMMENT '多选题id',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `score_limit` int default 5 COMMENT '选项分数上限，默认5分',
  PRIMARY KEY (`score_id`));
	/*主表控件表control和从表radio通过control_id建立引用关系*/
	/*ALTER TABLE score 
	ADD CONSTRAINT FK_s_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/

/*创建评分题逻辑设置表score_logic_setting*/
CREATE TABLE `surveys`.`score_logic_setting` (
  `score_logic_id` char(18) NOT NULL COMMENT '逻辑设置id',
  `score_id` char(18) NOT NULL COMMENT '与评分表关联，间接和控件表关联',
  `order_by_id` int NULL COMMENT '要设置的对应问题选项',
  `score_judgment` int NULL COMMENT '0为小等于，1为大等于',
  `score_num` int NULL COMMENT '判断依据，如大等于和5，则时大等于5分',
  `accord_style` int NULL COMMENT '0为显示，1为跳转',
  `logical_execution` int NULL COMMENT '注意0下标为默认文本，中间为问题，最后两个其他逻辑设置',
  PRIMARY KEY (`score_logic_id`));
	/*主表评分表score和从表score_logic_setting
		通过score_id建立引用关系*/
	/*ALTER TABLE score_logic_setting 
	ADD CONSTRAINT FK_sls_score_id
	FOREIGN KEY(score_id) REFERENCES score(score_id);*/

/*创建评分题选项表score_option*/
CREATE TABLE `surveys`.`score_option` (
  `so_id` char(18) NOT NULL COMMENT '逻辑设置id',
  `score_id` char(18) NOT NULL COMMENT '与评分表关联，间接和控件表关联',
  `option_name` varchar(20) NULL COMMENT '选项名称',
  `order_by_id` int NULL COMMENT '对应控件选项下标',
  `order_faction` int NULL COMMENT '评分数',
  PRIMARY KEY (`so_id`));
	/*主表评分表score和从表score_option
		通过score_id建立引用关系*/
	/*ALTER TABLE score_option 
	ADD CONSTRAINT FK_so_score_id
	FOREIGN KEY(score_id) REFERENCES score(score_id);*/

/*创建分页分段表page_section*/
CREATE TABLE `surveys`.`page_section` (
  `ps_id` char(18) NOT NULL COMMENT '主键',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `page_number` varchar(20) NULL COMMENT '分页当前页码',
  `page_numbers` int NULL COMMENT '分页总页数',
  `section_title` int NULL COMMENT '分段标题',
  PRIMARY KEY (`ps_id`));
	/*主表控件表control和从表page_section通过control_id建立引用关系*/
	/*ALTER TABLE page_section 
	ADD CONSTRAINT FK_ps_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
/*答卷收集表answer_collect*/
CREATE TABLE `surveys`.`answer_collect` (
  `ac_id` char(18) NOT NULL COMMENT '答卷收集id',
  `control_id` char(18) NOT NULL COMMENT '所属问卷id',
  `answer_id` char(18) NOT NULL COMMENT '回答用户id',
  `answer_ip` varchar(20) NOT NULL COMMENT '回答用户ip',
  `answer_address` varchar(20) NOT NULL COMMENT '回答用户地址',
  `answer_date` date NOT NULL COMMENT '回答时间，用户提交问卷的时间',
  `answer_num` int default 0 COMMENT '回答题数，用户回答并提交的题目数',
  PRIMARY KEY (`ac_id`));
	/*主表问卷表control和从表answer_collect通过control_id建立引用关系*/
	/*ALTER TABLE answer_collect ADD CONSTRAINT FK_ac_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表用户表user和从表answer_collect通过answer_id建立引用关系*/
	/*ALTER TABLE answer_collect ADD CONSTRAINT FK_ac_answer_id
	FOREIGN KEY(answer_id) REFERENCES user(user_id);*/
/*单选题答案表radio_answer*/
CREATE TABLE `surveys`.`radio_answer` (
  `ra_id` char(18) NOT NULL COMMENT '主键',
  `ac_id` char(18) NOT NULL COMMENT '与问卷收集表关联，
	根据问卷id和用户id找到答卷id，然后根据问卷id和控件id找到答案',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `answer_select` char(18) NOT NULL COMMENT '与单选题选项表关联',
  PRIMARY KEY (`ra_id`));
	/*主表答卷收集表answer_collect和
		从表radio_answer通过ac_id建立引用关系*/
	/*ALTER TABLE radio_answer 
	ADD CONSTRAINT FK_ra_ac_id
	FOREIGN KEY(ac_id) REFERENCES answer_collect(ac_id);*/
	/*主表控件表control和
		从表radio_answer通过control_id建立引用关系*/
	/*ALTER TABLE radio_answer 
	ADD CONSTRAINT FK_ra_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表单选题选项表radio_option和
		从表radio_answer通过answer_select建立引用关系*/
	/*ALTER TABLE radio_answer 
	ADD CONSTRAINT FK_ra_as_id
	FOREIGN KEY(answer_select) REFERENCES radio_option(ro_id);*/

/*多选题答案表chekbox_answer*/
CREATE TABLE `surveys`.`chekbox_answer` (
  `ca_id` char(18) NOT NULL COMMENT '主键',
  `ac_id` char(18) NOT NULL COMMENT '同上',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `answer_select` char(18) NOT NULL COMMENT '与多选题选项表关联',
  PRIMARY KEY (`ca_id`));
	/*主表答卷收集表answer_collect和
		从表chekbox_answer通过ac_id建立引用关系*/
	/*ALTER TABLE chekbox_answer 
	ADD CONSTRAINT FK_ca_ac_id
	FOREIGN KEY(ac_id) REFERENCES answer_collect(ac_id);*/
	/*主表控件表control和
		从表chekbox_answer通过control_id建立引用关系*/
	/*ALTER TABLE chekbox_answer 
	ADD CONSTRAINT FK_ca_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表多选题选项表checkbox_option和
		从表chekbox_answer通过answer_select建立引用关系*/
	/*ALTER TABLE chekbox_answer 
	ADD CONSTRAINT FK_ca_as_id
	FOREIGN KEY(answer_select) REFERENCES checkbox_option(co_id);*/

/*填空题答案表blank_answer*/
CREATE TABLE `surveys`.`blank_answer` (
  `ba_id` char(18) NOT NULL COMMENT '主键',
  `ac_id` char(18) NOT NULL COMMENT '同上',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `answer_select` char(18) NOT NULL COMMENT '与填空题表关联',
  PRIMARY KEY (`ba_id`));
	/*主表答卷收集表answer_collect和
		从表blank_answer通过ac_id建立引用关系*/
	/*ALTER TABLE blank_answer 
	ADD CONSTRAINT FK_ba_ac_id
	FOREIGN KEY(ac_id) REFERENCES answer_collect(ac_id);*/
	/*主表控件表control和
		从表blank_answer通过control_id建立引用关系*/
	/*ALTER TABLE blank_answer 
	ADD CONSTRAINT FK_ba_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表填空题表fillblank和
		从表blank_answer通过answer_select建立引用关系*/
	/*ALTER TABLE blank_answer 
	ADD CONSTRAINT FK_ba_as_id
	FOREIGN KEY(answer_select) REFERENCES fillblank(fillblank_id);*/


/*评分题答案表score_answer*/
CREATE TABLE `surveys`.`score_answer` (
  `sa_id` char(18) NOT NULL COMMENT '主键',
  `ac_id` char(18) NOT NULL COMMENT '同上',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联',
  `answer_select` char(18) NOT NULL COMMENT '与评分题选项表关联',
  PRIMARY KEY (`sa_id`));
	/*主表答卷收集表answer_collect和
		从表score_answer通过ac_id建立引用关系*/
	/*ALTER TABLE score_answer 
	ADD CONSTRAINT FK_sa_ac_id
	FOREIGN KEY(ac_id) REFERENCES answer_collect(ac_id);*/
	/*主表控件表control和
		从表score_answer通过control_id建立引用关系*/
	/*ALTER TABLE score_answer 
	ADD CONSTRAINT FK_sa_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表评分题选项表score_option和
		从表score_answer通过answer_select建立引用关系*/
	/*ALTER TABLE score_answer 
	ADD CONSTRAINT FK_sa_as_id
	FOREIGN KEY(answer_select) REFERENCES score_option(so_id);*/

/*创建问卷调查统计数据表survey_statistice*/
CREATE TABLE `surveys`.`survey_statistice` (
  `ss_id` char(18) NOT NULL COMMENT '统计数据id',
  `survey_id` char(18) NOT NULL COMMENT '与问卷表进行关联',
  `join_number` int default 0 COMMENT '根据问卷id找到答卷收集表，用count获取回答人数',
  `status` varchar(20) NULL COMMENT '问卷当前状态，由问卷id获取',
  PRIMARY KEY (`ss_id`));
/*问卷调查统计数据控件表survey_statistice_control*/
CREATE TABLE `surveys`.`survey_statistice_control` (
  `ssc_id` char(18) NOT NULL COMMENT '主键',
  `ss_id` char(18) NOT NULL COMMENT '与问卷统计数据表关联，获取一个问卷中所有答案数据',
  `control_id` char(18) NOT NULL COMMENT '与控件表关联，分别不同题目',
  `qa_id` char(18) NOT NULL COMMENT '与四类题答案表关联',
  PRIMARY KEY (`ssc_id`));
	/*主表问卷调查统计数据表survey_statistice和
		从表survey_statistice_control通过ss_id建立引用关系*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_ss_id
	FOREIGN KEY(ss_id) REFERENCES survey_statistice(ss_id);*/
	/*主表控件表control和
		从表survey_statistice_control通过control_id建立引用关系*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_control_id
	FOREIGN KEY(control_id) REFERENCES control(control_id);*/
	/*主表四个控件答案表和
		从表survey_statistice_control通过qa_id建立引用关系*/
		/*与单选题答案表关联*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_ra_id
	FOREIGN KEY(qa_id) REFERENCES radio_answer(ra_id);*/
		/*与多选题答案表关联*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_ca_id
	FOREIGN KEY(qa_id) REFERENCES chekbox_answer(ca_id);*/
		/*与填空题答案表关联*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_ba_id
	FOREIGN KEY(qa_id) REFERENCES blank_answer(ba_id);*/
		/*与评分题答案表关联*/
	/*ALTER TABLE survey_statistice_control 
	ADD CONSTRAINT FK_ssc_sa_id
	FOREIGN KEY(qa_id) REFERENCES score_answer(sa_id);*/

/*创建问卷调查风格表survey_style*/
CREATE TABLE `surveys`.`survey_style` (
  `ss_id` char(18) NOT NULL COMMENT '风格id',
  `survey_id` char(18) NOT NULL COMMENT '与问卷表关联',
  `body_bg_color` varchar(255) NULL COMMENT '页面整体背景颜色',
  `body_bg_image` varchar(255) NULL COMMENT '页面整体背景图片',
  `survey_content_bg_color_middle` varchar(255) NULL COMMENT '问卷背景颜色',
  `survey_content_bg_image_middle` varchar(255) NULL COMMENT '问卷背景图片',
  `survey_head_bg_color` varchar(255) NULL COMMENT '问卷头部背景颜色',
  `survey_head_bg_image` varchar(255) NULL COMMENT '问卷头部背景图片',
  `survey_width` int NULL COMMENT '问卷显示内容能够宽度',
  `survey_logo_image` varchar(255) NULL COMMENT '问卷logo图片，即在样式中显示的模板',
  `question_option_text_color` varchar(255) NULL COMMENT '问题字体颜色，针对问题字体',
  `question_title_text_color` varchar(255) NULL COMMENT '问题标题字体颜色,着呢对问题标题',
  `survey_note_text_color` varchar(255) NULL COMMENT '问卷注意文本字体颜色，针对问题注意文本',
  `survey_title_text_color` varchar(255) NULL COMMENT '问卷标题文本字体颜色，针对问卷标题',
  `survey_btn_bg_color` varchar(255) NULL COMMENT '问卷内容背景颜色，针对问卷内容背景',
  `show_survey_title` varchar(255) NULL COMMENT '样式名称，即样式中显示模板的名称',
  PRIMARY KEY (`ss_id`));
	/*主表问卷表survey和从表survey_style通过survey_id建立引用关系*/
	/*ALTER TABLE survey_style 
	ADD CONSTRAINT FK_ss_survey_id
	FOREIGN KEY(survey_id) REFERENCES survey(survey_id);*/