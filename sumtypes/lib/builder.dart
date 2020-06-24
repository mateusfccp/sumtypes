library sumtypes.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/sumtype_generator.dart';


Builder sumtypeBuilder(BuilderOptions options) =>
    SharedPartBuilder([SumtypeGenerator()], 'multiply');
