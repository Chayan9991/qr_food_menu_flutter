import 'package:dartz/dartz.dart';
import 'package:self_order_qr_menu/Core/Error/failures.dart';
import 'package:self_order_qr_menu/Core/UseCases/usecases.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_product_result.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/repositories/menu_repository.dart';
import '../entities/product_entity.dart';

class GetCategoryToProductsMapUseCase implements UseCase<CategoryProductResult, NoParams>{
  MenuRepository menuRepository ;
  GetCategoryToProductsMapUseCase(this.menuRepository);

  @override
  Future<Either<Failure, CategoryProductResult>> call(NoParams params) async{
    return await menuRepository.getCategoryToProductsMap() ;
  }

}