; ModuleID = '/home/alx/xil_proj/zynq_board/current/ip_hls_repo/scurve_adder_1/scurve_adder_1/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@scurve_adder_str = internal unnamed_addr constant [13 x i8] c"scurve_adder\00"
@llvm_global_ctors_1 = appending global [0 x void ()*] zeroinitializer
@llvm_global_ctors_0 = appending global [0 x i32] zeroinitializer
@p_str7 = private unnamed_addr constant [12 x i8] c"hls_label_2\00", align 1
@p_str6 = private unnamed_addr constant [12 x i8] c"hls_label_1\00", align 1
@p_str5 = private unnamed_addr constant [12 x i8] c"hls_label_0\00", align 1
@p_str4 = private unnamed_addr constant [9 x i8] c"CTRL_BUS\00", align 1
@p_str3 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1
@p_str2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str1 = private unnamed_addr constant [5 x i8] c"both\00", align 1
@p_str = private unnamed_addr constant [5 x i8] c"axis\00", align 1

define void @scurve_adder(i16* %in_stream0_V_data_V, i2* %in_stream0_V_keep_V, i2* %in_stream0_V_strb_V, i2* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V, i64* %out_stream_V_data_V, i8* %out_stream_V_keep_V, i8* %out_stream_V_strb_V, i2* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, i16 zeroext %N_ADDS) {
.preheader124:
  call void (...)* @_ssdm_op_SpecBitsMap(i16* %in_stream0_V_data_V), !map !63
  call void (...)* @_ssdm_op_SpecBitsMap(i2* %in_stream0_V_keep_V), !map !67
  call void (...)* @_ssdm_op_SpecBitsMap(i2* %in_stream0_V_strb_V), !map !71
  call void (...)* @_ssdm_op_SpecBitsMap(i2* %in_stream0_V_user_V), !map !75
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_stream0_V_last_V), !map !79
  call void (...)* @_ssdm_op_SpecBitsMap(i5* %in_stream0_V_id_V), !map !83
  call void (...)* @_ssdm_op_SpecBitsMap(i6* %in_stream0_V_dest_V), !map !87
  call void (...)* @_ssdm_op_SpecBitsMap(i64* %out_stream_V_data_V), !map !91
  call void (...)* @_ssdm_op_SpecBitsMap(i8* %out_stream_V_keep_V), !map !95
  call void (...)* @_ssdm_op_SpecBitsMap(i8* %out_stream_V_strb_V), !map !99
  call void (...)* @_ssdm_op_SpecBitsMap(i2* %out_stream_V_user_V), !map !103
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_stream_V_last_V), !map !107
  call void (...)* @_ssdm_op_SpecBitsMap(i5* %out_stream_V_id_V), !map !111
  call void (...)* @_ssdm_op_SpecBitsMap(i6* %out_stream_V_dest_V), !map !115
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %N_ADDS), !map !119
  call void (...)* @_ssdm_op_SpecTopModule([13 x i8]* @scurve_adder_str) nounwind
  %N_ADDS_read = call i16 @_ssdm_op_Read.s_axilite.i16(i16 %N_ADDS)
  %sum_pix1_ch0 = alloca [32 x i32], align 16
  %sum_pix2_ch0 = alloca [32 x i32], align 16
  %dub_pix_ch0_user_V = alloca [32 x i2], align 1
  %dub_pix_ch0_id_V = alloca [32 x i5], align 1
  %dub_pix_ch0_dest_V = alloca [32 x i6], align 1
  call void (...)* @_ssdm_op_SpecInterface(i16* %in_stream0_V_data_V, i2* %in_stream0_V_keep_V, i2* %in_stream0_V_strb_V, i2* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V, [5 x i8]* @p_str, i32 1, i32 1, [5 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i64* %out_stream_V_data_V, i8* %out_stream_V_keep_V, i8* %out_stream_V_strb_V, i2* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, [5 x i8]* @p_str, i32 1, i32 1, [5 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i16 %N_ADDS, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  br label %0

; <label>:0                                       ; preds = %1, %.preheader124
  %i = phi i6 [ %i_3, %1 ], [ 0, %.preheader124 ]
  %exitcond1 = icmp eq i6 %i, -32
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 32, i64 32, i64 32)
  %i_3 = add i6 %i, 1
  br i1 %exitcond1, label %.preheader1.preheader, label %1

.preheader1.preheader:                            ; preds = %0
  %tmp = call i21 @_ssdm_op_BitConcatenate.i21.i16.i5(i16 %N_ADDS_read, i5 0)
  br label %.preheader85

; <label>:1                                       ; preds = %0
  %tmp_7 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str5)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_1 = zext i6 %i to i64
  %sum_pix1_ch0_addr = getelementptr inbounds [32 x i32]* %sum_pix1_ch0, i64 0, i64 %tmp_1
  store i32 0, i32* %sum_pix1_ch0_addr, align 4
  %sum_pix2_ch0_addr = getelementptr inbounds [32 x i32]* %sum_pix2_ch0, i64 0, i64 %tmp_1
  store i32 0, i32* %sum_pix2_ch0_addr, align 4
  %empty_5 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str5, i32 %tmp_7)
  br label %0

.preheader.preheader:                             ; preds = %.preheader85
  %dub_pix_ch0_user_V_a = getelementptr [32 x i2]* %dub_pix_ch0_user_V, i64 0, i64 0
  %dub_pix_ch0_id_V_add = getelementptr [32 x i5]* %dub_pix_ch0_id_V, i64 0, i64 0
  %dub_pix_ch0_dest_V_a = getelementptr [32 x i6]* %dub_pix_ch0_dest_V, i64 0, i64 0
  %sum_pix_tot_user_V = load i2* %dub_pix_ch0_user_V_a, align 4
  %sum_pix_tot_id_V = load i5* %dub_pix_ch0_id_V_add, align 2
  %sum_pix_tot_dest_V = load i6* %dub_pix_ch0_dest_V_a, align 1
  br label %.preheader

.preheader85:                                     ; preds = %.preheader1.preheader, %.preheader1
  %indvar_flatten = phi i21 [ 0, %.preheader1.preheader ], [ %indvar_flatten_next, %.preheader1 ]
  %i_1 = phi i6 [ 0, %.preheader1.preheader ], [ %i_5, %.preheader1 ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, %tmp
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.preheader.preheader, label %.preheader1

.preheader1:                                      ; preds = %.preheader85
  %exitcond2 = icmp eq i6 %i_1, -32
  %i_1_mid2 = select i1 %exitcond2, i6 0, i6 %i_1
  %tmp_4 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str6)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_s = zext i6 %i_1_mid2 to i64
  %empty_6 = call { i16, i2, i2, i2, i1, i5, i6 } @_ssdm_op_Read.axis.volatile.i16P.i2P.i2P.i2P.i1P.i5P.i6P(i16* %in_stream0_V_data_V, i2* %in_stream0_V_keep_V, i2* %in_stream0_V_strb_V, i2* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V)
  %tmp_data_V = extractvalue { i16, i2, i2, i2, i1, i5, i6 } %empty_6, 0
  %tmp_user_V = extractvalue { i16, i2, i2, i2, i1, i5, i6 } %empty_6, 3
  %tmp_id_V = extractvalue { i16, i2, i2, i2, i1, i5, i6 } %empty_6, 5
  %tmp_dest_V = extractvalue { i16, i2, i2, i2, i1, i5, i6 } %empty_6, 6
  %dub_pix_ch0_user_V_a_1 = getelementptr [32 x i2]* %dub_pix_ch0_user_V, i64 0, i64 %tmp_s
  store i2 %tmp_user_V, i2* %dub_pix_ch0_user_V_a_1, align 4
  %dub_pix_ch0_id_V_add_1 = getelementptr [32 x i5]* %dub_pix_ch0_id_V, i64 0, i64 %tmp_s
  store i5 %tmp_id_V, i5* %dub_pix_ch0_id_V_add_1, align 2
  %dub_pix_ch0_dest_V_a_1 = getelementptr [32 x i6]* %dub_pix_ch0_dest_V, i64 0, i64 %tmp_s
  store i6 %tmp_dest_V, i6* %dub_pix_ch0_dest_V_a_1, align 1
  %tmp_2 = trunc i16 %tmp_data_V to i8
  %phitmp = call i8 @_ssdm_op_PartSelect.i8.i16.i32.i32(i16 %tmp_data_V, i32 8, i32 15)
  %tmp_9 = zext i8 %tmp_2 to i32
  %sum_pix1_ch0_addr_2 = getelementptr inbounds [32 x i32]* %sum_pix1_ch0, i64 0, i64 %tmp_s
  %sum_pix1_ch0_load_1 = load i32* %sum_pix1_ch0_addr_2, align 4
  %tmp_8 = add nsw i32 %tmp_9, %sum_pix1_ch0_load_1
  store i32 %tmp_8, i32* %sum_pix1_ch0_addr_2, align 4
  %tmp_10 = zext i8 %phitmp to i32
  %sum_pix2_ch0_addr_2 = getelementptr inbounds [32 x i32]* %sum_pix2_ch0, i64 0, i64 %tmp_s
  %sum_pix2_ch0_load_1 = load i32* %sum_pix2_ch0_addr_2, align 4
  %tmp_11 = add nsw i32 %tmp_10, %sum_pix2_ch0_load_1
  store i32 %tmp_11, i32* %sum_pix2_ch0_addr_2, align 4
  %empty_7 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str6, i32 %tmp_4)
  %i_5 = add i6 1, %i_1_mid2
  br label %.preheader85

.preheader:                                       ; preds = %2, %.preheader.preheader
  %i_2 = phi i6 [ %i_4, %2 ], [ 0, %.preheader.preheader ]
  %exitcond = icmp eq i6 %i_2, -32
  %empty_8 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 32, i64 32, i64 32)
  %i_4 = add i6 %i_2, 1
  br i1 %exitcond, label %3, label %2

; <label>:2                                       ; preds = %.preheader
  %tmp_12 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str7)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_3 = zext i6 %i_2 to i64
  %sum_pix2_ch0_addr_1 = getelementptr inbounds [32 x i32]* %sum_pix2_ch0, i64 0, i64 %tmp_3
  %sum_pix2_ch0_load = load i32* %sum_pix2_ch0_addr_1, align 4
  %tmp_5 = call i64 @_ssdm_op_BitConcatenate.i64.i32.i32(i32 %sum_pix2_ch0_load, i32 0)
  %sum_pix1_ch0_addr_1 = getelementptr inbounds [32 x i32]* %sum_pix1_ch0, i64 0, i64 %tmp_3
  %sum_pix1_ch0_load = load i32* %sum_pix1_ch0_addr_1, align 4
  %tmp_6 = sext i32 %sum_pix1_ch0_load to i64
  %tmp_data_V_1 = or i64 %tmp_5, %tmp_6
  %tmp_last_V = icmp eq i6 %i_2, 31
  call void @_ssdm_op_Write.axis.volatile.i64P.i8P.i8P.i2P.i1P.i5P.i6P(i64* %out_stream_V_data_V, i8* %out_stream_V_keep_V, i8* %out_stream_V_strb_V, i2* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, i64 %tmp_data_V_1, i8 63, i8 63, i2 %sum_pix_tot_user_V, i1 %tmp_last_V, i5 %sum_pix_tot_id_V, i6 %sum_pix_tot_dest_V)
  %empty_9 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str7, i32 %tmp_12)
  br label %.preheader

; <label>:3                                       ; preds = %.preheader
  ret void
}

declare i16 @llvm.part.select.i16(i16, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define weak void @_ssdm_op_Write.axis.volatile.i64P.i8P.i8P.i2P.i1P.i5P.i6P(i64*, i8*, i8*, i2*, i1*, i5*, i6*, i64, i8, i8, i2, i1, i5, i6) {
entry:
  store i64 %7, i64* %0
  store i8 %8, i8* %1
  store i8 %9, i8* %2
  store i2 %10, i2* %3
  store i1 %11, i1* %4
  store i5 %12, i5* %5
  store i6 %13, i6* %6
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecPipeline(...) nounwind {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i16 @_ssdm_op_Read.s_axilite.i16(i16) {
entry:
  ret i16 %0
}

define weak { i16, i2, i2, i2, i1, i5, i6 } @_ssdm_op_Read.axis.volatile.i16P.i2P.i2P.i2P.i1P.i5P.i6P(i16*, i2*, i2*, i2*, i1*, i5*, i6*) {
entry:
  %empty = load i16* %0
  %empty_10 = load i2* %1
  %empty_11 = load i2* %2
  %empty_12 = load i2* %3
  %empty_13 = load i1* %4
  %empty_14 = load i5* %5
  %empty_15 = load i6* %6
  %mrv_0 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } undef, i16 %empty, 0
  %mrv1 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv_0, i2 %empty_10, 1
  %mrv2 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv1, i2 %empty_11, 2
  %mrv3 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv2, i2 %empty_12, 3
  %mrv4 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv3, i1 %empty_13, 4
  %mrv5 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv4, i5 %empty_14, 5
  %mrv6 = insertvalue { i16, i2, i2, i2, i1, i5, i6 } %mrv5, i6 %empty_15, 6
  ret { i16, i2, i2, i2, i1, i5, i6 } %mrv6
}

define weak i8 @_ssdm_op_PartSelect.i8.i16.i32.i32(i16, i32, i32) nounwind readnone {
entry:
  %empty = call i16 @llvm.part.select.i16(i16 %0, i32 %1, i32 %2)
  %empty_16 = trunc i16 %empty to i8
  ret i8 %empty_16
}

define weak i64 @_ssdm_op_BitConcatenate.i64.i32.i32(i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %0 to i64
  %empty_17 = zext i32 %1 to i64
  %empty_18 = shl i64 %empty, 32
  %empty_19 = or i64 %empty_18, %empty_17
  ret i64 %empty_19
}

define weak i21 @_ssdm_op_BitConcatenate.i21.i16.i5(i16, i5) nounwind readnone {
entry:
  %empty = zext i16 %0 to i21
  %empty_20 = zext i5 %1 to i21
  %empty_21 = shl i21 %empty, 5
  %empty_22 = or i21 %empty_21, %empty_20
  ret i21 %empty_22
}

!opencl.kernels = !{!0, !7, !13, !13, !16, !16, !13, !13, !16, !16, !22, !25, !25, !16, !16, !27, !16, !29, !16, !16, !16, !16, !35, !37, !37, !16, !39, !16, !16, !41, !41, !43, !45, !47, !49, !16, !51, !54, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!56}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"STREAM_16 &", metadata !"STREAM_64 &", metadata !"uint16_t"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"in_stream0", metadata !"out_stream", metadata !"N_ADDS"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"const struct ap_axis<64, 2, 5, 6> &"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"din"}
!13 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !15, metadata !6}
!14 = metadata !{metadata !"kernel_arg_type", metadata !"int"}
!15 = metadata !{metadata !"kernel_arg_name", metadata !"val"}
!16 = metadata !{null, metadata !17, metadata !18, metadata !19, metadata !20, metadata !21, metadata !6}
!17 = metadata !{metadata !"kernel_arg_addr_space"}
!18 = metadata !{metadata !"kernel_arg_access_qual"}
!19 = metadata !{metadata !"kernel_arg_type"}
!20 = metadata !{metadata !"kernel_arg_type_qual"}
!21 = metadata !{metadata !"kernel_arg_name"}
!22 = metadata !{null, metadata !8, metadata !9, metadata !23, metadata !11, metadata !24, metadata !6}
!23 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<8> &"}
!24 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!25 = metadata !{null, metadata !8, metadata !9, metadata !26, metadata !11, metadata !15, metadata !6}
!26 = metadata !{metadata !"kernel_arg_type", metadata !"long"}
!27 = metadata !{null, metadata !8, metadata !9, metadata !28, metadata !11, metadata !24, metadata !6}
!28 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<64> &"}
!29 = metadata !{null, metadata !30, metadata !31, metadata !32, metadata !33, metadata !34, metadata !6}
!30 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!31 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!32 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, true> &", metadata !"int"}
!33 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!34 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!35 = metadata !{null, metadata !30, metadata !31, metadata !32, metadata !33, metadata !36, metadata !6}
!36 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!37 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !38, metadata !6}
!38 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!39 = metadata !{null, metadata !30, metadata !31, metadata !40, metadata !33, metadata !34, metadata !6}
!40 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, true> &", metadata !"const ap_int_base<32, true> &"}
!41 = metadata !{null, metadata !8, metadata !9, metadata !42, metadata !11, metadata !38, metadata !6}
!42 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, true> &"}
!43 = metadata !{null, metadata !8, metadata !9, metadata !44, metadata !11, metadata !24, metadata !6}
!44 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<6> &"}
!45 = metadata !{null, metadata !8, metadata !9, metadata !46, metadata !11, metadata !24, metadata !6}
!46 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<5> &"}
!47 = metadata !{null, metadata !8, metadata !9, metadata !48, metadata !11, metadata !24, metadata !6}
!48 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<1> &"}
!49 = metadata !{null, metadata !8, metadata !9, metadata !50, metadata !11, metadata !24, metadata !6}
!50 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<2> &"}
!51 = metadata !{null, metadata !8, metadata !9, metadata !52, metadata !11, metadata !53, metadata !6}
!52 = metadata !{metadata !"kernel_arg_type", metadata !"const struct ap_axis<16, 2, 5, 6> &"}
!53 = metadata !{metadata !"kernel_arg_name", metadata !""}
!54 = metadata !{null, metadata !8, metadata !9, metadata !55, metadata !11, metadata !24, metadata !6}
!55 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<16> &"}
!56 = metadata !{metadata !57, [0 x i32]* @llvm_global_ctors_0}
!57 = metadata !{metadata !58}
!58 = metadata !{i32 0, i32 31, metadata !59}
!59 = metadata !{metadata !60}
!60 = metadata !{metadata !"llvm.global_ctors.0", metadata !61, metadata !"", i32 0, i32 31}
!61 = metadata !{metadata !62}
!62 = metadata !{i32 0, i32 0, i32 1}
!63 = metadata !{metadata !64}
!64 = metadata !{i32 0, i32 15, metadata !65}
!65 = metadata !{metadata !66}
!66 = metadata !{metadata !"in_stream0.V.data.V", metadata !61, metadata !"int16", i32 0, i32 15}
!67 = metadata !{metadata !68}
!68 = metadata !{i32 0, i32 1, metadata !69}
!69 = metadata !{metadata !70}
!70 = metadata !{metadata !"in_stream0.V.keep.V", metadata !61, metadata !"uint2", i32 0, i32 1}
!71 = metadata !{metadata !72}
!72 = metadata !{i32 0, i32 1, metadata !73}
!73 = metadata !{metadata !74}
!74 = metadata !{metadata !"in_stream0.V.strb.V", metadata !61, metadata !"uint2", i32 0, i32 1}
!75 = metadata !{metadata !76}
!76 = metadata !{i32 0, i32 1, metadata !77}
!77 = metadata !{metadata !78}
!78 = metadata !{metadata !"in_stream0.V.user.V", metadata !61, metadata !"uint2", i32 0, i32 1}
!79 = metadata !{metadata !80}
!80 = metadata !{i32 0, i32 0, metadata !81}
!81 = metadata !{metadata !82}
!82 = metadata !{metadata !"in_stream0.V.last.V", metadata !61, metadata !"uint1", i32 0, i32 0}
!83 = metadata !{metadata !84}
!84 = metadata !{i32 0, i32 4, metadata !85}
!85 = metadata !{metadata !86}
!86 = metadata !{metadata !"in_stream0.V.id.V", metadata !61, metadata !"uint5", i32 0, i32 4}
!87 = metadata !{metadata !88}
!88 = metadata !{i32 0, i32 5, metadata !89}
!89 = metadata !{metadata !90}
!90 = metadata !{metadata !"in_stream0.V.dest.V", metadata !61, metadata !"uint6", i32 0, i32 5}
!91 = metadata !{metadata !92}
!92 = metadata !{i32 0, i32 63, metadata !93}
!93 = metadata !{metadata !94}
!94 = metadata !{metadata !"out_stream.V.data.V", metadata !61, metadata !"int64", i32 0, i32 63}
!95 = metadata !{metadata !96}
!96 = metadata !{i32 0, i32 7, metadata !97}
!97 = metadata !{metadata !98}
!98 = metadata !{metadata !"out_stream.V.keep.V", metadata !61, metadata !"uint8", i32 0, i32 7}
!99 = metadata !{metadata !100}
!100 = metadata !{i32 0, i32 7, metadata !101}
!101 = metadata !{metadata !102}
!102 = metadata !{metadata !"out_stream.V.strb.V", metadata !61, metadata !"uint8", i32 0, i32 7}
!103 = metadata !{metadata !104}
!104 = metadata !{i32 0, i32 1, metadata !105}
!105 = metadata !{metadata !106}
!106 = metadata !{metadata !"out_stream.V.user.V", metadata !61, metadata !"uint2", i32 0, i32 1}
!107 = metadata !{metadata !108}
!108 = metadata !{i32 0, i32 0, metadata !109}
!109 = metadata !{metadata !110}
!110 = metadata !{metadata !"out_stream.V.last.V", metadata !61, metadata !"uint1", i32 0, i32 0}
!111 = metadata !{metadata !112}
!112 = metadata !{i32 0, i32 4, metadata !113}
!113 = metadata !{metadata !114}
!114 = metadata !{metadata !"out_stream.V.id.V", metadata !61, metadata !"uint5", i32 0, i32 4}
!115 = metadata !{metadata !116}
!116 = metadata !{i32 0, i32 5, metadata !117}
!117 = metadata !{metadata !118}
!118 = metadata !{metadata !"out_stream.V.dest.V", metadata !61, metadata !"uint6", i32 0, i32 5}
!119 = metadata !{metadata !120}
!120 = metadata !{i32 0, i32 15, metadata !121}
!121 = metadata !{metadata !122}
!122 = metadata !{metadata !"N_ADDS", metadata !123, metadata !"unsigned short", i32 0, i32 15}
!123 = metadata !{metadata !124}
!124 = metadata !{i32 0, i32 0, i32 0}
